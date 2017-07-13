class CaliberSample < ApplicationRecord
  include SoftDeletable


  belongs_to :element
  belongs_to :caliber
  has_one :deviation_sample

  # before_save :calculate_caliber
  before_validation :calculate_caliber

  validates :element, :responsable, :fruits_per_pound, :fruits_in_sample, :sample_weight, :caliber, presence: true
  validates :fruits_per_pound, :fruits_in_sample, :sample_weight, numericality: true


  def calculate_caliber
    # TODO TEST
    # NOTE Division de enteros es por defecto aproximada en cada calculo
    grams_per_lb = Rails.configuration.grams_per_lb
    self.fruits_per_pound = (self.fruits_in_sample.to_f /  self.sample_weight) * grams_per_lb
    self.caliber = Caliber.first
    Caliber.all.each do |cal|
      if self.fruits_per_pound > cal.minimum && self.fruits_per_pound < cal.maximum
         self.caliber = cal and break
      end
    end
  end

end
