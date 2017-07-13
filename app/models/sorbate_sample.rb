class SorbateSample < ApplicationRecord
  include SoftDeletable

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

end
