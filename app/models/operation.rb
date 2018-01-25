class Operation < ApplicationRecord

  validates :name,  uniqueness: true, presence: true

end
