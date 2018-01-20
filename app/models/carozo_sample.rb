class CarozoSample < ApplicationRecord
  include SoftDeletable
  include Methods
  include ProcessIndependentSamplesModels
  include SamplesModelMethods

  enum status: [:rechazado, :aprobado]
  belongs_to :element

  before_validation :calculate_status

  validates :element, :responsable, :carozo_weight, :sample_weight, :carozo_percentage, presence: true
  validates :carozo_weight, :sample_weight, :carozo_percentage, numericality: true


  def calculate_status
    # TODO: Hacer tests que chequeen limite.
    # El % de carozo se rechaza porque es mayor a un n fijo
    max = 5 # % TODO: move to config
    self.carozo_percentage = ((self.carozo_weight/ self.sample_weight) * 100).round(2)
    puts "porc #{self.carozo_percentage}"
    self.status = "rechazado"
    self.status = "aprobado" if self.carozo_percentage < max
  end

end
