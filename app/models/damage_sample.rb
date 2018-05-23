class DamageSample < ApplicationRecord
  include SoftDeletable
  include AllSamplesMethods
  include Methods
  include SamplesModelMethods
  include RefreshSamplesAverages

  enum usda: [:A, :B, :C, :SSTD, :no_califica]
  enum df07: [:rechazado, :aprobado]

  belongs_to :element, optional: true
  belongs_to :elements_group, optional: true
  alias_attribute :group, :elements_group

  validate :has_element_or_group

  # delegate :product_type, :to => :element, :allow_nil => true

  before_validation :calculate_percentages
  before_validation :calculate_usda
  before_validation :calculate_df07

  before_create :increase_and_store_counter

  validates :responsable, :sample_weight, :usda, presence: true
  validates :sample_weight, numericality: true

  ### Metodos para hacer que sea posible trabajar con elem y group ####
  #####################################################################
  def product_type
    return self.element.product_type if self.element
    return self.group.product_type if self.group
    nil
  end
  # Get all Damage_Samples of a process
  def self.process(process)
    group_or_elem = Util.group_or_elem(process)
    product_type = ProductType.find_by_process(process) # if process = recepcion_seco, lo convierte a secado
    product_type.dam_samples(group_or_elem)
  end
  #####################################################################

  def calculate_percentages
    total = 0
    Util.damages_of_product_type("all").each do |damage_name|
      total += calculate_one_percentage (damage_name)
    end
    self.total_damages = total
    self.total_damages_perc = (total.to_f * 100)/ self.sample_weight
    calculate_one_percentage ("carozo")
  end

  # Para cada atributo _porc calcula su porcentaje
  def calculate_one_percentage (damage_name)
    grams = self.send(damage_name)
    if grams
      percentage = (grams * 100)/ self.sample_weight
      self.send("#{damage_name}_perc=", percentage)
    else
      self.send("#{damage_name}_perc=", 0)
    end
    grams || 0
  end

  def increase_and_store_counter
    Count.increase_and_store_counter(self, "damage_sample")
  end

  # Calcula y almacena el estandar USDA
  def calculate_usda
    Usda.calculate_and_store_usda(self)
  end

  # Calcula y almacena el estandar DF07
  def calculate_df07
    # Note Calculo DF07 deberia ir en un modulo aparte como Usda
    puts self.product_type.name
    pitted = (self.product_type.name == "tsc"? true : false)
    puts self.inspect
    puts "pitted: #{pitted}"

    g1 = Util.df07_g1 (self)
    g2 = Util.df07_g2 (self)
    g3 = Util.df07_g3 (self)
    g4 = Util.df07_g4 (self)
    g5 = Util.df07_g5 (self)
    g6 = Util.df07_g6 (self)
    g7 = Util.df07_g7 (self)

    puts "g1: #{g1}"
    puts "g2: #{g2}"
    puts "g3: #{g3}"
    puts "g4: #{g4}"
    puts "g5: #{g5}"
    puts "g6: #{g6}"
    puts "g7: #{g7}"

    self.df07 = :aprobado

    if g1 > 12
      self.df07 = :rechazado

    elsif g2 > 12
      self.df07 = :rechazado

    elsif g3 > 8
      self.df07 = :rechazado
    elsif pitted and g3 > 2
      self.df07 = :rechazado

    elsif g4 > 4
      self.df07 = :rechazado
    elsif pitted and g4 > 2
      self.df07 = :rechazado

    elsif g5 > 1
      self.df07 = :rechazado

    elsif g6 > 1
      self.df07 = :rechazado
    elsif pitted and g6 > 0.5
      self.df07 = :rechazado

    elsif g7 > 0.5
      self.df07 = :rechazado

    elsif pitted and self.carozo_perc > 2
      self.df07 = :rechazado
    end

  end


  # NOTE sgts 3 Metodos adaptados para soportar elements_group
  # Obtiene ultimas quantity muestras de daños del process
  def self.get_samples(process, responsable = nil)
    samples = DamageSample.process(process).active.ord
    return samples if !responsable
    samples.where(responsable: responsable)
  end

  def self.get_recent_samples(process, responsable = nil)
    t = Rails.configuration.max_sample_hrs
    samples = DamageSample.get_samples(process, responsable)
    samples = samples.where('damage_samples.created_at > ?', t.hours.ago)
  end

  def self.in_user_last_samples(sample, responsable, number, process = nil)
    samples = DamageSample.process(process)
    samples = samples.where(responsable: responsable)
    .where('damage_samples.created_at > ?', Rails.configuration.max_sample_hrs.hours.ago)
    samples = samples.ord.ids.first(number)
    # print samples
    ret = sample.id.in?(samples)
    return ret
  end

end
