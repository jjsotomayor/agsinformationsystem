class Element < ApplicationRecord
  include Methods
  include ColorCalculation
  include ErrorFinder

  # NOTE Nunca cambiar el orden de los enum, alterara el valor de los registros en ls db!
  enum color: [:-, :azul, :verde, :amarillo, :rojo]
  # enum previous_usda: [:A, :B, :C, :SSTD, :'no califica']
  #enum status: [ :active, :archived ]
  enum last_movement_type: [:ingreso, :edicion, :salida, :salida_rectifica_error, :devolucion_bins_incompleto]

  belongs_to :product_type, optional: true
  belongs_to :drying_method, optional: true
  belongs_to :warehouse, optional: true

  belongs_to :elements_group, optional: true
  alias_attribute :group, :elements_group

  has_many :damage_samples
  has_many :caliber_samples
  has_many :humidity_samples
  has_many :sorbate_samples
  has_many :carozo_samples

  has_one :samples_average, dependent: :destroy

  has_many :movements, dependent: :destroy

  validates :tag,  uniqueness: true, presence: true
  validates :weight, numericality: {greater_than: 0}, allow_nil: true
  # validates :product_type, presence: true. No esta cuando secrea humidity sample antes q otra

  scope :last_move_type, -> (type) { where last_movement_type: type }
  scope :product_type, -> (product_type_id) { where product_type_id: product_type_id }
  scope :drying_method, -> (drying_method_id) { where drying_method_id: drying_method_id }
  scope :color, -> (color) { where color: color }

  before_save :find_possible_error, on: [:create, :update]

  #### Metodos asociados con la existencia de grupos ###
  def belongs_to_group?
     self.group ? true : false
  end
  # Obtiene caliber_samples, a traves de group de ser necesario
  def get_caliber_samples
    # p "Accediendo a caliber_samples"
    self.group ? self.group.caliber_samples : self.caliber_samples
  end

  # Obtiene damage_samples, a traves de group de ser necesario
  def get_damage_samples
    # p "Accediendo a damage_samples"
    self.group ? self.group.damage_samples : self.damage_samples
  end
  # Obtiene humidity_samples, a traves de group de ser necesario
  def get_humidity_samples
    # p "Accediendo a humidity_samples"
    self.group ? self.group.humidity_samples : self.humidity_samples
  end

  def self.get_by_process(process)
    # p "Entro get by process"
    pt = ProductType.find_by_process(process)
    elems = pt.elements.includes(:drying_method)

    if process.in? ["secado", "recepcion_seco"]
      # dmethods = DryingMethod.all.to_a
      if process == "recepcion_seco"
        dmethods_ids = DryingMethod.where(name: "sol").ids
      else #secado
        # Se pone asi pq si tiene sol siempre es recepcion y si tiene nil será "secado"
        dmethods_ids = DryingMethod.where.not(name: "sol").ids + [nil]
      end
      elems = elems.where(drying_method_id: dmethods_ids)
    end

    # p "Salgo get by process"
    elems
  end

  # Actualiza los averages en tabla samples_average q permite generar excel bodega
  # Se debe llamar cada vez que ingresa algo a bodega o se toma muestra de algo de bodega.
  # LA idea es que se llame dentro de un Thread.new do
  def refresh_samples_averages
    # Thread.abort_on_exception = true # PErmite q haya error cdo se cae Thread, es para debuguear
    # Cuando un thread que no es main se cae, no hay ningun aviso
    # p " ESTOY EN refresh_samples_averages de Element"
    # sleep 2 # NOTE lo habia probado siempre antes de comentar esto!
    return if !self.has_entered_warehouse? or !self.product_type
    # p " ESTOY EN refresh_samples_averages de Element2222"
    if self.samples_average
      self.samples_average.refresh
    else
      SamplesAverage.create(element: self)
    end
    # p "FINALIZADO SAMPLES AVERAGEE!"
  end


  def self.location(location_id) # Filter
    # ["Toda ubicación", 0], ["En bodega", 1]
    if location_id == "1"
      where.not(warehouse_id: nil)
    else
      all
    end
  end

  def self.to_csv
    attributes = %w{Tarja N OrdenProceso Producto Secado UsdaAnterior TarjaAnterior}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      attributes_originals = %w{tag id process_order product_type drying_method_id previous_usda ex_tag}
      all.each do |element|
        # csv << attributes_originals.map{ |attr| element.send(attr) }
        row = [element.tag, element.id, element.process_order]

        if element.product_type.nil?
          row << ""
        else
          row << element.product_type.name
        end

        if element.drying_method.nil?
          row << ""
        else
          row << element.drying_method.name
        end

        row << element.previous_usda
        row << element.ex_tag

        csv << row#[element.tag, element.id, element.process_order, element.product_type]
      end
    end
  end

  # Permite crear/encontrar elemento para las muestras de elementos (no elementos de grupo)
  # Retorna [elemento, Boolean] Boolean true si esta todo Ok
  def self.create_element_if_doesnt_exist(element_params, process_name = nil)
    # TODO Aqui seria necesario tener un lock y una transaction al parecer
    @element = Element.find_by(tag: element_params[:tag])

    # Si el proceso del elemento almacenado es distinto al proceso actual
    if @element and @element.product_type and process_name and @element.product_type.name != process_name
      logger.info "Muestra RECIEN almacenada ES DE OTRO PROCESO #{@element.product_type.name}"
      return @element, false
    elsif @element and @element.group #El elemento encontrado es un elemento grupal
      # NOTE Msje mostrado a usuario será el mismo que para WrONG PROCESS ERROR
      logger.info "Tarja de muestra RECIEN ingresada corresponde a tarja de grupo! No guardada"
      return @element, false
    end

    if @element
      if !@element.product_type and process_name
        @element.product_type = ProductType.find_by(name: process_name)
      end
      # TODO Actualizar estado de productos que dependen del proceso,(humedad, q otro)
      # Si existia el @element actualizo de ser nec. con los datos de la muestra,
      @element.update_attributes(element_params) if element_params.count > 1
    else #!@element
      @element = Element.new(element_params)
      @element.product_type = ProductType.find_by(name: process_name) if process_name
    end
    @element.save!

    return @element, true
  end

  # Permite desasociar sample de un element y asociarlo a otro.
  # Si element queda vacio y no está en una bodega, se elimina.(Pq la sample lo creo por error)
  def self.change_element_of_sample(sample, element_params, process = nil)
    @original_element = sample.element
    # Crea element con el nuevo tag
    @new_element, status = Element.create_element_if_doesnt_exist(element_params, process)
    return @new_element, false if !status # Element es de otro proceso

    time_diff1 = (@original_element.updated_at - sample.created_at).abs
    time_diff2 = (@original_element.updated_at - sample.updated_at).abs # Permite editar varias veces tarja eliminando la mal creada

    # Se le asigna el new_element a sample
    sample.update(element: @new_element)

    time_difference = [time_diff1, time_diff2].min
    #Si original_element vacio y no se ha tocado desde que se creo la muestra erronea
    if @original_element.samples_count == 0 and time_difference < 0.5
      logger.info "Element erroneo #{@original_element.tag} se creo con la muestra a la q se le está editando tarja -> BORRAR elem"
      # NOTE Unico lugar donde se destruyen elements
      @original_element.destroy
      # Por seguridad element no tiene dependent destroy, para no borrar muestras por accidente
    end

    return @element, status # status = true
  end

  # Retorna la cantidad de muestras de un element.
  def samples_count
    count = 0
    sample_types = Util.all_required_samples(:all) - [:deviation]
    sample_types.each do |sample_type|
      count += self.send(sample_type.to_s + "_samples").count
    end
    count
  end

  # Busca por tag si le pasan un term, sino retorna todos
  def self.search(term = nil)
    if term
      where('tag LIKE ?', "%#{term}%").ord
    else
      ord
    end
  end
  # def valid?
  #   if Element.find_by(tag: self.tag)
  #     return false, 'Error: Ya existe producto con esa tarja/folio!'
  #   elsif !self.product_type
  #     return false, 'Error: Falta ingresar el Tipo de producto'
  #   end
  #   true
  # end

  ##########################################################
  ################## Metodos para bodega ###################
  ##########################################################

  def in_warehouse?
    return self.warehouse ? true : false
  end

  def left_warehouse?
    return self.dispatched_at ? true : false
  end

  #NOTE Esto deberia ser solamente return true if stored_at
  def has_entered_warehouse?
    # return true if self.stored_at No se esta borrando al sacar por error
    return true if self.warehouse || self.dispatched_at
    false
  end

  # Si hay varios ingresos y salidas quedara registrada la primera entrada
  # y la ultima salida
  # Responsable se actualiza cuando entra, sale, o se edita el producto
  def enter_warehouse(enter_params)
    now = Time.now
    move_params = enter_params.clone
    enter_params[:stored_at] = now if !self.stored_at
    enter_params[:last_movement_at] = now
    enter_params[:last_movement_type] = :ingreso
    enter_params[:dispatched_at] = nil
    enter_params[:destination] = nil
    enter_params[:process_order] = nil
    move_params[:element_id] = self.id
    move_params[:movement_type] = :ingreso
    ActiveRecord::Base.transaction do
      self.update!(enter_params)
      Movement.create!(move_params)
    end
    Thread.new do
      self.refresh_samples_averages
    end
  end

  def remove_from_warehouse(exit_params, error)
    now = Time.now
    params = {warehouse_id: nil, banda: nil, posicion: nil, altura: nil,
        warehouse_responsable: exit_params[:warehouse_responsable],
        last_movement_at: now} #Se registra sea salida corrigiendo error o normal
    move_params = {element_id: self.id, warehouse_responsable: params[:warehouse_responsable]}

    if error
      params = params.merge({dispatched_at: nil, last_movement_type: :salida_rectifica_error, weight: nil})
      #stored_at lo deja nil solo si el 1ER INGRESO(STORED) fue el ultimo edicion (stored_at = last_movement_at)
      params[:stored_at] = nil if self.stored_at == self.last_movement_at
      move_params[:movement_type] = :salida_rectifica_error
    else
      # logger.info "#{self.tag} Sacado de bodega normal!"
      params = params.merge({dispatched_at: now, last_movement_type: :salida})
      params = params.merge(exit_params) # Tiene destino, OP, responsable(repetido)
      move_params[:movement_type] = :salida
      move_params = move_params.merge(exit_params.slice(:destination, :process_order))
    end
    ActiveRecord::Base.transaction do
      self.update!(params)
      pp move_params
      Movement.create!(move_params)
    end
  end

  # Crea copia de element y añade overwrite_params, retorna elem + status
  def self.create_copy(element, overwrite_params, resp)
    # FIXME revisar todos los save! quizas hay que cambiarlos por otra cosa
    now = Time.now
    # NOTE Cada vez que se agreguen columnas a element actualizar este metodo!
    @new_element = Element.new
    @new_element.assign_attributes(element.attributes.slice("lot", "product_type_id", "drying_method_id", "ex_tag", "previous_color"))
    @new_element.assign_attributes(overwrite_params)
    # NOTE first_item y last_item no copiados. Podria ser fuente de error
    @new_element.incomplete_bin_tag = element.tag
    @new_element.stored_at = now
    @new_element.last_movement_at = now
    @new_element.warehouse_responsable = resp
    @new_element.last_movement_type = :devolucion_bins_incompleto

    move_params = overwrite_params.slice(:weight, :warehouse_id, :banda, :posicion, :altura)
    move_params[:movement_type] = :devolucion_bins_incompleto
    move_params[:warehouse_responsable] = resp
    move_params[:incomplete_bin_tag] = element.tag

    ActiveRecord::Base.transaction do
      @new_element.save!
      element.update!(weight: element.weight - @new_element.weight) # Actualiza peso tarja original
      move_params[:element_id] = @new_element.id
      Movement.create!(move_params)
    end

    ####### Duplicar muestras! #######
    # NOTE Esto podria ser un proceso after job! Que responda al user aqui.
    sample_types = Util.all_required_samples(:all) - [:deviation]
    sample_types.each do |sample_type|
      logger.info "Duplicando muestras #{sample_type}"
      element.send(sample_type.to_s + "_samples").each do |sample|
        # logger.info "Duplicando muestra #{sample.id}"
        new_sample = sample.dup
        new_sample.element = @new_element
        new_sample.save

        # Deviation Samples se tratan aparte
        logger.info {"Copiando dev_samples"}
        if sample.class.name == "CaliberSample" and sample.deviation_sample
          new_dev_sample = sample.deviation_sample.dup
          new_dev_sample.caliber_sample = new_sample
          new_dev_sample.save
        end

      end
    end
    return @new_element, true
  end


  def find_possible_error
    begin # Permite que no se caiga programa si metodo se cae
      self.possible_error = find_possible_error_in_element(self)
    rescue =>e
     logger.info "Error en Find_possible_error"
     Raygun.track_exception(e) # Permite que quede registro en Raygun
    end
  end

end
