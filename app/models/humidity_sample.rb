class HumiditySample < ApplicationRecord
  include SoftDeletable

  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element

  before_save :calculate_status # FIXME PORque funciona??

  validates :element, :responsable, :humidity, :status, presence: true
  validates :humidity, numericality: true

   # Considera el proceso actual del element
   def calculate_status
     # TODO: Hacer tests que chequeen todos los limites.
     # TODO Crear funcion entre() que retorne true o false. Usar aqui y en sorbato
     self.status = "pendiente" and return if !self.element.product_type
     min = self.element.product_type.humidity_min
     max = self.element.product_type.humidity_max
     puts "Min: #{min}, MAx: #{max}"
     self.status = "aprobado"
     if min and self.humidity < min
       self.status = "rechazado"
     elsif max and self.humidity > max
       self.status = "rechazado"
     end
   end

 end
