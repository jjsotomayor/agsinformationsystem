class CarozoSample < ApplicationRecord
  include SoftDeletable
  include AllSamplesMethods
  include Methods
  include ProcessIndependentSamplesModels
  include SamplesModelMethods

  enum status: [:rechazado, :aprobado]
  belongs_to :element
  delegate :product_type, :to => :element, :allow_nil => true

  before_validation :calculate_percentage

  validates :element, :responsable, :carozo_weight, :sample_weight, :carozo_percentage, presence: true
  validates :carozo_weight, :sample_weight, :carozo_percentage, numericality: true


  def calculate_percentage
    self.carozo_percentage = ((self.carozo_weight/ self.sample_weight) * 100).round(2)
    # NOTE Aqui calcular aceptacion/rechazo si se implementa
  end

end
