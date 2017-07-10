class HumiditySample < ApplicationRecord
  enum status: [:rechazado, :aprobado]

  belongs_to :element

  before_save :calculate_status

  validates :element, :responsable, :humidity, :status, presence: true
  validates :humidity, numericality: true
  validates :status, inclusion: { in: %w(aprobado rechazado)}


   def calculate_status
    #  Rails.configuration.firebase_url
     limit = Rails.configuration.humidity_limit
     self.status = "rechazado"
     if self.humidity < limit
       self.status = "aprobado"
     end
   end

  def self.last_humidity_samples(number)
    HumiditySample.last(number).reverse
  end


 end
