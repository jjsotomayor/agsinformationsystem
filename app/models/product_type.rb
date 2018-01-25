class ProductType < ApplicationRecord

  validates :name,  uniqueness: true, presence: true

  has_many :elements
  has_many :damage_samples, :through => :elements
  has_many :caliber_samples, :through => :elements
  has_many :humidity_samples, :through => :elements
  has_many :sorbate_samples, :through => :elements
  has_many :carozo_samples, :through => :elements
end
