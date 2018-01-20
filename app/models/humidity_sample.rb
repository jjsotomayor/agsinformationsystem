class HumiditySample < ApplicationRecord
  include SoftDeletable
  include Methods
  include ProcessIndependentSamplesModels
  include SamplesModelMethods

  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element

  # before_validation :calculate_status

  validates :element, :responsable, :humidity, presence: true #, :status
  validates :humidity, numericality: true

   # Considera el proceso actual del element
   def calculate_status #(No usado)
     # TODO: Testear
     self.status = "pendiente" and return if !self.element.product_type
     min = self.element.product_type.humidity_min
     max = self.element.product_type.humidity_max
     puts "Min: #{min}, Max: #{max}"
     self.status = between?(self.humidity, min, max) ? "aprobado" : "rechazado"
   end

 end
