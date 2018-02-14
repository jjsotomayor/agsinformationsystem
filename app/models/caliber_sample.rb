class CaliberSample < ApplicationRecord
  include SoftDeletable
  include AllSamplesMethods
  include Methods

  belongs_to :element, optional: true
  belongs_to :elements_group, optional: true
  alias_attribute :group, :elements_group

  validate :has_element_or_group

  belongs_to :caliber
  has_one :deviation_sample, dependent: :destroy
  # delegate :product_type, :to => :element, :allow_nil => true

  before_validation :calculate_caliber

  before_create :increase_and_store_counter

  validates :responsable, :fruits_per_pound, :fruits_in_sample, :sample_weight, :caliber, presence: true
  validates :fruits_per_pound, :fruits_in_sample, :sample_weight, numericality: true

  ### Metodos para hacer que sea posible trabajar con elem y group ####
  #####################################################################
  def product_type
    return self.element.product_type if self.element
    return self.group.product_type if self.group
    nil
  end
  # Get all Caliber_Samples of a process
  def self.process(process)
    group_or_elem = Util.group_or_elem(process)
    product_type = ProductType.find_by_process(process) # if process = recepcion_seco, lo convierte a secado
    product_type.cal_samples(group_or_elem)
  end
  #####################################################################

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

  # NOTE sgts 3 Metodos adaptados para soportar elements_group
  # NOTE se asume que cuando se está en recepcion, todas las muestras son grupales
  # Process no es = pt
  # Obtiene ultimas quantity muestras de daños del process
  def self.get_samples(process, responsable = nil)
    samples = CaliberSample.process(process).active.ord
    return samples if !responsable
    samples.where(responsable: responsable)
  end

  def self.get_recent_samples(process, responsable = nil)
    t = Rails.configuration.max_sample_hrs
    samples = CaliberSample.get_samples(process, responsable)
    samples = samples.where('caliber_samples.created_at > ?', t.hours.ago)
  end

  def self.in_user_last_samples(sample, responsable, number, process = nil)
    samples = CaliberSample.process(process)
    samples = samples.where(responsable: responsable)
    .where('caliber_samples.created_at > ?', Rails.configuration.max_sample_hrs.hours.ago)
    samples = samples.ord.ids.first(number)
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
