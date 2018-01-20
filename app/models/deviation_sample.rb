class DeviationSample < ApplicationRecord
  #NOTE: No es necesario soft_delete pq se esconde cuando se borra caliber_sample
  enum status: [:rechazado, :aprobado]

  belongs_to :caliber_sample

  before_validation :calculate_deviation

  validates :big_fruits_in_sample, :small_fruits_in_sample, presence: true
  validates :deviation, :status, presence: true

  validates :big_fruits_in_sample, :small_fruits_in_sample, :deviation, numericality: true

  def calculate_deviation
    self.big_fruits_in_sample
    self.small_fruits_in_sample
    dev_weight = Rails.configuration.deviation_calc_weight # 283
    # self.sample_weight = 2830

    grams_per_lb = Rails.configuration.grams_per_lb
    self.big_fruits_per_pound = (self.big_fruits_in_sample.to_f/dev_weight) * grams_per_lb
    self.small_fruits_per_pound = (self.small_fruits_in_sample.to_f/dev_weight) * grams_per_lb
    # p self.big_fruits_per_pound
    # p self.small_fruits_per_pound
    self.deviation = (self.big_fruits_per_pound - self.small_fruits_per_pound).abs.round(2)

    # puts max_deviation
    self.status = self.deviation < max_deviation ? "aprobado" : "rechazado"
  end

  private

  def max_deviation
    limit = Rails.configuration.limit_big_small_caliber # 50
    if self.caliber_sample.fruits_per_pound <= limit
      Rails.configuration.max_deviation_big_caliber # 20
    else
      Rails.configuration.max_deviation_small_caliber # 43
    end
  end

end
