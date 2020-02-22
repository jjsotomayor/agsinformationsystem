class Movement < ApplicationRecord
  belongs_to :element
  belongs_to :warehouse, optional: true

  enum movement_type: [:ingreso, :edicion, :salida, :salida_rectifica_error, :devolucion_bins_incompleto]

  scope :movement_type, -> (type) { where movement_type: type }


  def self.product_type(product_type_id)
    element_ids = ProductType.find(product_type_id).elements
    where(element_id: element_ids)
  end

end
