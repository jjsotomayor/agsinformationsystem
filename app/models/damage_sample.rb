class DamageSample < ApplicationRecord
  include SoftDeletable
  include Methods
  enum usda: [:A, :B, :C, :SSTD, :no_califica]

  belongs_to :element

  before_validation :calculate_percentages
  before_validation :calculate_usda
  before_validation :calculate_df07

  validates :element, :responsable, :sample_weight, :usda, :df07, presence: true
  validates :sample_weight, :usda, numericality: true


  def calculate_percentages
    # FIXME
  end

  def calculate_usda
    # FIXME
    self.A!
  end

  def calculate_df07
    # FIXME
    self.df07 = false
  end

end
