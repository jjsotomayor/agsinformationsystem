class CaliberSample < ApplicationRecord
  include SoftDeletable
  include Methods

  belongs_to :element
  belongs_to :caliber
  has_one :deviation_sample
  delegate :product_type, :to => :element, :allow_nil => true

  before_validation :calculate_caliber

  before_create :increase_and_store_counter

  validates :element, :responsable, :fruits_per_pound, :fruits_in_sample, :sample_weight, :caliber, presence: true
  validates :fruits_per_pound, :fruits_in_sample, :sample_weight, numericality: true


  def calculate_caliber
    # TODO TEST
    # NOTE Division de enteros es por defecto aproximada en cada calculo
    grams_per_lb = Rails.configuration.grams_per_lb
    self.fruits_per_pound = ((self.fruits_in_sample.to_f /  self.sample_weight) * grams_per_lb).round(0)
    caliber_to_use = self.caliber_to_use
    Caliber.all.each do |cal|
      if between_min_max?(caliber_to_use, cal.minimum, cal.maximum)
         self.caliber = cal and break
      end
    end
  end

  def increase_and_store_counter
    Count.increase_and_store_counter(self, "caliber_sample")
  end

  # Obtiene ultimas quantity muestras de daños del process
  def self.get_samples(process, responsable = nil)
    product_type = ProductType.find_by(name: process)
    caliber_samples =  product_type.caliber_samples.active.ord
    return caliber_samples if !responsable
    caliber_samples.where(responsable: responsable)
  end

  def self.get_recent_samples(process, responsable = nil)
    t = Rails.configuration.max_sample_hrs
    cal_samples = CaliberSample.get_samples(process, responsable)
    cal_samples = cal_samples.where('caliber_samples.created_at > ?', t.hours.ago)
  end

  def self.in_user_last_samples(sample, responsable, number, process = nil)
    pt = ProductType.find_by(name: process)
    samples = pt.caliber_samples
    samples = samples.where(responsable: responsable)
    .where('caliber_samples.created_at > ?', Rails.configuration.max_sample_hrs.hours.ago)
    samples = samples.order('caliber_samples.created_at DESC').ids.first(number)
    # print samples
    ret = sample.id.in?(samples)
    return ret
  end

  # Retorna el calibre a usar para calcular el rango de calibre, en TSC no se usa el real.
  def caliber_to_use
    fruitspp = self.fruits_per_pound
    if self.product_type.name == "tsc" and !self.is_ex_caliber
      # Se calcula el calibre proyectado con carozo(ex-calibre) para TSC
      limit = Rails.configuration.ex_caliber_limit_big_small_caliber# = 85 #Menor o igual a 85, se suma 15.
      big_fruits_sub = Rails.configuration.ex_caliber_big_fruits_subtraction# = 15
      small_fruits_sub = Rails.configuration.ex_caliber_small_fruits_subtraction# = 20
      fruitspp <= limit ? fruitspp - big_fruits_sub : fruitspp - small_fruits_sub
    else
      fruitspp
    end
  end
end
