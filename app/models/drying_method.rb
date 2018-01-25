class DryingMethod < ApplicationRecord
  # belongs_to :element
  validates :name,  uniqueness: true, presence: true

end
