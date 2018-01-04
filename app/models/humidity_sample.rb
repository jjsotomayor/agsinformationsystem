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
     self.status = between?(self.humidity, min, max) ? "aprobado" : "rechazado"
   end

   def counter # Metodo para modelos que usan el id como contador
     self.id
   end
 end
