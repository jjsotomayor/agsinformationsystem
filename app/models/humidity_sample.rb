class HumiditySample < ApplicationRecord
  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element

  before_save :calculate_status

  validates :element, :responsable, :humidity, :status, presence: true
  validates :humidity, numericality: true

  scope :active, -> { where(active: true) }

   # Considera el proceso actual del element
   def calculate_status
     # TODO: Hacer tests que chequeen todos los limites.
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

  # def self.last_humidity_samples(number)
  #   HumiditySample.last(number).reverse
  # end

  def soft_delete
    # TODO: Pasarlo a un modulo
    self.deleted_at = Time.zone.now
    self.active = false
    self.save!
  end

 end
