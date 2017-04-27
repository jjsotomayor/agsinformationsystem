class SorbateSample < ApplicationRecord
  enum state: [:rechazado, :aprobado]
  belongs_to :element
end
