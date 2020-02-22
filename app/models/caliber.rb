class Caliber < ApplicationRecord

  validates :name,  uniqueness: true, presence: true
end
