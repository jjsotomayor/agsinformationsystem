class IpAddress < ApplicationRecord
  validates :ip, { presence: true }
end
