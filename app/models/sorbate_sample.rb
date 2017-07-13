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
    min = Rails.configuration.min_sorbate
    max = Rails.configuration.max_sorbate
    self.status = between(self.sorbate, max, min) ? "aprobado" : "rechazado"
  end

  def between(value, max, min = nil)
    # TODOMOVE to lib module
    if min and value < min
      return false
    elsif value > max
      return false
    end
    return true

  end

end
