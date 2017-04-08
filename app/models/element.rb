class Element < ApplicationRecord
  belongs_to :product_type
  belongs_to :drying_method

  validates :tag,  uniqueness: true
end
