class CaliberSample < ApplicationRecord
  before_save :calculate_caliber
  
  belongs_to :element
  belongs_to :caliber
end

def calculate_caliber
  #TESTEAR
  self.fruits_per_pound = (self.fruits_in_sample /  self.sample_weight) * 453.592
  self.fruits_per_pound= 50
  self.caliber = Caliber.first
end
