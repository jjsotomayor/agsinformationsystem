class HumiditySample < ApplicationRecord
  include SoftDeletable
  include Methods

  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element

  before_validation :calculate_status

  validates :element, :responsable, :humidity, :status, presence: true
  validates :humidity, numericality: true

   # Considera el proceso actual del element
   def calculate_status
     # TODO: Hacer tests que chequeen todos los limites.
     self.status = "pendiente" and return if !self.element.product_type
     min = self.element.product_type.humidity_min
     max = self.element.product_type.humidity_max
     puts "Min: #{min}, Max: #{max}"
     self.status = between?(self.sorbate, min, max) ? "aprobado" : "rechazado"
   end

 end
