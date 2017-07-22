class Element < ApplicationRecord
  enum previous_usda: [:A, :B, :C, :SSTD, :'no califica']
  #enum status: [ :active, :archived ]

  belongs_to :product_type
  belongs_to :drying_method
  has_many :damage_samples

  validates :tag,  uniqueness: true, presence: true

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
  def self.create_element_if_doesnt_exist(element_params, process_name = nil)
    @element = Element.find_by(tag: element_params[:tag])
    if !@element
      @element = Element.new(element_params)
      @element.product_type = ProductType.find_by(name: process_name) if process_name
      @element.save!
    end
    return @element
  end

end
