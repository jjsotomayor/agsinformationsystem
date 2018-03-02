class SorbateSample < ApplicationRecord
  include SoftDeletable
  include AllSamplesMethods
  include Methods
  include ProcessIndependentSamplesModels
  include SamplesModelMethods
  include RefreshSamplesAverages

  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element
  delegate :product_type, :to => :element, :allow_nil => true

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
