class HumiditySample < ApplicationRecord
  belongs_to :element

  before_create :calculate_state
  before_save :calculate_state

  validates :element, :responsable, :humidity, presence: true
  validates :humidity, numericality: true
  #validates :state, inclusion: { in: %w(aprobado rechazado)}


   def calculate_state
     self.state = "aprobado"
     puts "LEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEM1!!!!"
     if self.humidity > 20
       self.state = "rechazado"
     end
   end

 end
