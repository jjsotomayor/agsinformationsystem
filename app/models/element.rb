class Element < ApplicationRecord
  include Methods

  enum color: [:-, :azul, :verde, :amarillo, :rojo]
  # enum previous_usda: [:A, :B, :C, :SSTD, :'no califica']
  #enum status: [ :active, :archived ]

  belongs_to :product_type, optional: true
  belongs_to :drying_method, optional: true
  has_many :damage_samples
  has_many :caliber_samples
  has_many :humidity_samples
  has_many :sorbate_samples
  has_many :carozo_samples

  validates :tag,  uniqueness: true, presence: true
  # validates :product_type, presence: true. No esta cuando secrea humidity sample antes q otra

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


  # Retorna [elemento, Boolean] Boolean true si esta todo Ok
  def self.create_element_if_doesnt_exist(element_params, process_name = nil)
    @element = Element.find_by(tag: element_params[:tag])

    # Si el proceso del elemento almacenado es distinto al proceso actual
    if @element and @element.product_type and process_name and @element.product_type.name != process_name
      logger.info "Muestra RECIEN almacenada ES DE OTRO PROCESO #{@element.product_type.name}"
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

  # Actualiza color de element de ser necesario.
  def refresh_element_color
    logger.info {"Revisando si se actualizan colores de element #{self.tag}!!!"}
    if self.all_samples_taken?
      self.calculate_color
    elsif self.product_type
      self.check_if_red_color
    end
  end

  ######################################################
  ###### SOLO LLAMAR DESDE REFRESH ELEMENT COLOR #######
  ######################################################

  def all_samples_taken?
    return false if !pt = self.product_type
    return false if self.damage_samples.count == 0
    return false if self.humidity_samples.count == 0
    req_samples = Util.required_samples(pt.name)
    return false if :sorbate.in?(req_samples) and self.sorbate_samples.count == 0
    return false if :carozo.in?(req_samples) and self.carozo_samples.count == 0
    true
  end

  # Se llama cada vez que se completan todas las muestras nec. para calcular color
  def calculate_color
    # t1 = Time.current
    logger.info {"All samples taken -> CALCULANDO COLOR"}
    process = self.product_type.name
    required_samples = Util.required_samples(process)
    current_color = 1

    humidity_color = :humidity.in?(required_samples) ? worst_humidity_color(process) : 1
    logger.info {"Humidity Color #{humidity_color}"}
    sorbate_color = :sorbate.in?(required_samples) ? worst_sorbate_color : 1
    logger.info {"Sorbate Color #{sorbate_color}"}
    carozo_color = :carozo.in?(required_samples) ? worst_carozo_color : 1
    logger.info {"Carozo Color #{carozo_color}"}
    damage_color = :damage.in?(required_samples) ? worst_damage_color(process) : 1
    logger.info {"Damage Color #{damage_color}"}

    # Set the worst color and store it in element table!
    current_color = [humidity_color, sorbate_color, carozo_color, damage_color].max
    self.update(color: current_color)
    # t2 = Time.current
    # puts "Finalizado el calculo de color"
    # puts "T1: #{t1}"
    # puts "T2: #{t2}"
    # puts "Diferencia: #{t2-t1}"
  end

  # Revisa si hay muestra en rojo, si no lo hay lo pone en color= 0
  # Solo ejecutar cuando no se ejecute calculate_color, pq lo sobreescribiria!
  def check_if_red_color
    logger.info {"Revisando si hay color rojo"}
    process = self.product_type.name
    colors = []
    colors << worst_sorbate_color if self.sorbate_samples.count > 0
    colors << worst_humidity_color(process) if self.humidity_samples.count > 0
    # Si habia un rojo (4) lo pongo en rojo, sino indeterminado
    color = colors.max == 4 ? 4 : 0
    self.update(color: color)
  end


  private

  #############################################
  ####### Metodos para determinar color #######
  #############################################

  def worst_humidity_color(process)
    logger.info {"Buscando peor Humedad"}
    limits = Util.color_humidity_limits(process)
    sample_values = self.humidity_samples.pluck(:humidity)
    worst_color_for_sample_group(sample_values, limits)
  end

  def worst_sorbate_color
    logger.info {"Buscando peor Sorbato"}
    limits = Util.color_sorbate_limits()
    sample_values = self.sorbate_samples.pluck(:sorbate)
    worst_color_for_sample_group(sample_values, limits)
  end

  # NOTE Este podria ser mucho mas rapido al tomar el maximo y ver en q rango queda
  def worst_carozo_color
    logger.info {"Buscando peor Carozo"}
    limits = Util.color_carozo_limits()
    sample_values = self.carozo_samples.pluck(:carozo_percentage)
    worst_color_for_sample_group(sample_values, limits)
  end

  def worst_damage_color(process)
    logger.info {"Buscando peor Daño"}
    if process.in? ["tsc", "tcc"]
      limits = Util.color_damage_limits(process)
      sample_values = self.damage_samples.pluck(:total_damages_perc)
      worst_color_for_sample_group(sample_values, limits)
    else # Process calibrado/Secado/recepcion/seam/cn
      limits = Util.color_damage_limits(process)
      sample_values = self.damage_samples.select(:total_damages_perc, :foreign_material_perc,
        :vegetal_foreign_material_perc, :dirt_perc, :off_color_perc).map {
        |ds| {not_all: ds.total_damages_perc - ds.foreign_material_perc -
          ds.vegetal_foreign_material_perc - ds.dirt_perc - ds.off_color_perc,
              all: ds.total_damages_perc}
      }
      worst_color_damage_calibrado_group(sample_values, limits)
    end
  end

  # Retorna peor color dedaño para elems de procesos calibrado/Secado/recepcion/seam/cn
  # Recibe sample_values de la forma [{not_all: x, all: y}, {not_all: x, all: y}]
  def worst_color_damage_calibrado_group(sample_values, limits)
    worst_color = 1
    sample_values.each do |damages|
      limits.each do |range|

        logger.info {"Muestra de daños: #{damages}"}
        value = range[:sum] == :all ? damages[:all] : damages[:not_all]
        logger.info {"Value: #{value}"}
        logger.info {"Rango => #{range}"}
        if between_min_max?(value, range[:min],  range[:max])
          worst_color = max(worst_color, range[:color])
          logger.info {"Entre, worst_color del group: #{worst_color}"}
          break
        end
      end
    end
    worst_color
  end

  # Retorna peor color para una lista de daños sample_values y limites.
  def worst_color_for_sample_group(sample_values, limits)
    worst_color = 1
    # Recorre cada muestra
    sample_values.each do |value|
      # Recorre cada rango para ver donde esta esa muestra
      limits.each do |range|
        logger.info {"Min: #{range[:min]}, Max: #{range[:max]}, Valor: #{value}"}
        if between_min_max?(value, range[:min],  range[:max])
          worst_color = max(worst_color, range[:color])
          logger.info {"Entre, worst_color del group: #{worst_color}"}
          break
        end
      end
    end
    worst_color
  end



end
