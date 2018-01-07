class Element < ApplicationRecord
  enum previous_usda: [:A, :B, :C, :SSTD, :'no califica']
  #enum status: [ :active, :archived ]

  belongs_to :product_type
  belongs_to :drying_method
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


  # TODO, si implemento el ajax fill del form, aqui podria implementar el update tag (mejor q no en verdad)
  # Retorna [elemento, Boolean] Boolean true si esta todo Ok
  def self.create_element_if_doesnt_exist(element_params, process_name = nil)
    @element = Element.find_by(tag: element_params[:tag])

    # Si el proceso del elemento almacenado es distinto al proceso actual
    if @element and @element.product_type and process_name and @element.product_type.name != process_name
      puts "Muestra RECIEN almacenada ES DE OTRO PROCESO #{@element.product_type.name}"
      return @element, false
    end

    # TODO Dentro de este if podria gatillar actualizar el estado pendiente de humiditysamples
    # Si existia el @element actualizo de ser nec. con los datos de la muestra,
    if @element and element_params.count > 1# Si se ingresaron varios parametros del producto #!@element.product_type and process_name
      @element.product_type = ProductType.find_by(name: process_name) if process_name
      @element.update_attributes(element_params)
    elsif !@element
      @element = Element.new(element_params)
      @element.product_type = ProductType.find_by(name: process_name) if process_name
      @element.save!
    end
    return @element, true
  end

  # def valid?
  #   if Element.find_by(tag: self.tag)
  #     return false, 'Error: Ya existe producto con esa tarja/folio!'
  #   elsif !self.product_type
  #     return false, 'Error: Falta ingresar el Tipo de producto'
  #   end
  #   true
  # end

end
