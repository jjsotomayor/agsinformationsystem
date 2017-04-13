class DeviationSample < ApplicationRecord
  enum state: [:rechazado, :aprobado]

  belongs_to :caliber_sample
end
