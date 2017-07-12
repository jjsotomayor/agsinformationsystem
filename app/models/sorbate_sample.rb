class SorbateSample < ApplicationRecord
  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element

  before_save :calculate_status

  validates :element, :responsable, :sorbate, :status, presence: true
  validates :sorbate, numericality: true

  scope :active, -> { where(active: true) }
  # Considera el proceso actual del element
  #NOTE: Sorbato es independiente del producto
  def calculate_status
    # TODO: Hacer tests que chequeen todos los limites.
    # TODO: Move to config file or to table
    min = 1000
    max = 1200
    puts "Min: #{min}, Max: #{max}"
    self.status = "aprobado"
    if min and self.sorbate < min
      self.status = "rechazado"
    elsif max and self.sorbate > max
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

 # def self.active
 #   # TODO: Pasarlo a un modulo
 #   # TODO: HAcer que siempre por defecto se llamen las active
 #   where(active: true)
 # end

end
