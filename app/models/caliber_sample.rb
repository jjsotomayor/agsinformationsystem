class CaliberSample < ApplicationRecord
  include SoftDeletable
  # include Methods


  belongs_to :element
  belongs_to :caliber
  has_one :deviation_sample
  delegate :product_type, :to => :element, :allow_nil => true

  before_validation :calculate_caliber

  before_save :increase_and_store_counter

  validates :element, :responsable, :fruits_per_pound, :fruits_in_sample, :sample_weight, :caliber, presence: true
  validates :fruits_per_pound, :fruits_in_sample, :sample_weight, numericality: true


  def calculate_caliber
    # TODO TEST
    # NOTE Division de enteros es por defecto aproximada en cada calculo
    grams_per_lb = Rails.configuration.grams_per_lb
    self.fruits_per_pound = (self.fruits_in_sample.to_f /  self.sample_weight) * grams_per_lb
    Caliber.all.each do |cal|
      if self.fruits_per_pound >= cal.minimum && self.fruits_per_pound <= cal.maximum
         self.caliber = cal and break
      end
    end
  end

  def increase_and_store_counter
    Count.increase_and_store_counter(self, "caliber_sample")
  end

  # Obtiene ultimas quantity muestras de daños del process
  def self.get_samples(process, responsable = nil)
    puts "PRoceso : #{process}"
    product_type = ProductType.find_by(name: process)
    caliber_samples =  product_type.caliber_samples.active.order('created_at DESC')
    return caliber_samples if ! responsable
    caliber_samples.where(responsable: responsable)
  end

end
