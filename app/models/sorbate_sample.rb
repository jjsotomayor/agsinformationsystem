class SorbateSample < ApplicationRecord
  include SoftDeletable
  include Methods
  include ProcessIndependentSamplesModels
  include SamplesModelMethods

  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element

  # before_validation :calculate_status

  validates :element, :responsable, :sorbate, presence: true #, :status
  validates :sorbate, numericality: true

  # Sorbato es independiente del producto
  def calculate_status #(No usado)
    # TODO: Hacer tests que chequeen todos los limites.
    min = Rails.configuration.min_sorbate
    max = Rails.configuration.max_sorbate
    self.status = between?(self.sorbate, min, max) ? "aprobado" : "rechazado"
  end

end
