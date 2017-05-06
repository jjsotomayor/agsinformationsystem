class HumiditySample < ApplicationRecord
  enum state: [:rechazado, :aprobado]

  belongs_to :element

  before_create :calculate_state
  before_save :calculate_state

  validates :element, :responsable, :humidity, presence: true
  validates :humidity, numericality: true
  #validates :state, inclusion: { in: %w(aprobado rechazado)}


   def calculate_state
     #TESTEAR
     self.state = "aprobado"
     #puts "LEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEM1!!!!"
     if self.humidity > 20
       self.state = "rechazado"
     end
   end

  def self.last_humidity_samples(number)
    HumiditySample.last(number).reverse
  end


 end
