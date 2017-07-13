class DeviationSample < ApplicationRecord
  #NOTE: No es necesario soft_delete pq se esconde cuando se borra caliber_sample
  enum status: [:rechazado, :aprobado]

  belongs_to :caliber_sample

  before_validation :calculate_deviation

  validates :big_fruits_in_sample, :small_fruits_in_sample, presence: true
  validates :deviation, :status, presence: true

  validates :big_fruits_in_sample, :small_fruits_in_sample, :deviation, numericality: true

  # FIXME: Arreglar calculos
  def calculate_deviation
    self.big_fruits_in_sample
    self.small_fruits_in_sample
    self.sample_weight = self.caliber_sample.sample_weight

    grams_per_lb = Rails.configuration.grams_per_lb
    self.big_fruits_per_pound = (self.big_fruits_in_sample.to_f/self.sample_weight) * grams_per_lb
    self.small_fruits_per_pound = (self.small_fruits_in_sample.to_f/self.sample_weight) * grams_per_lb
    self.deviation = self.big_fruits_per_pound - self.small_fruits_per_pound

    self.status = "rechazado"
    self.status = "aprobado" if self.deviation < 40
  end

end
