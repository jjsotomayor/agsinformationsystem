class ProductType < ApplicationRecord

  has_many :elements
  has_many :damage_samples, :through => :elements
end
