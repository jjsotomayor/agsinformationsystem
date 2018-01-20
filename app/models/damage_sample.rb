class DamageSample < ApplicationRecord
  include SoftDeletable
  include Methods
  include SamplesModelMethods

  enum usda: [:A, :B, :C, :SSTD, :no_califica]
  enum df07: [:rechazado, :aprobado]

  belongs_to :element
  delegate :product_type, :to => :element, :allow_nil => true

  before_validation :calculate_percentages
  before_validation :calculate_usda
  before_validation :calculate_df07

  before_create :increase_and_store_counter

  validates :element, :responsable, :sample_weight, :usda, presence: true
  validates :sample_weight, numericality: true


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
    #FIXME test
    self.usda = :no_califica
    grado_a = true
    grado_b = true
    grado_c = true
    grado_sstd = true

    group_a = self.decay_perc
    group_b = group_a + Util.usda_inc_b(self)
    group_c = group_b + Util.usda_inc_c(self)
    group_d = group_c + Util.usda_inc_d(self)
    group_e = group_d + Util.usda_inc_e(self)
    group_f = group_e + Util.usda_inc_f(self)
    group_g = group_f - self.poor_texture_perc

    puts "a: #{group_a}"
    puts "b: #{group_b}"
    puts "c: #{group_c}"
    puts "d: #{group_d}"
    puts "e: #{group_e}"
    puts "f: #{group_f}"
    puts "g: #{group_g}"

    if group_f > 20
      grado_a = false
      grado_b = false
      grado_c = false
    end

    if group_g > 15
      grado_a = false
      grado_b = false
    elsif group_g > 10
      grado_a = false
    end

    if group_e > 8
      grado_a = false
      grado_b = false
    elsif group_e > 6
      grado_a = false
    end

    if group_d > 10
      grado_a = false # Se podria omitir
      grado_b = false # Se podria omitir
      grado_c = false
    end

    if group_c > 10 # Deberia ser 8 segun USDA, pero interpretamos conv.
      grado_a = false # Se podria omitir
      grado_b = false # Se podria omitir
      grado_c = false
    end

    if group_b > 5
      grado_a = false
      grado_b = false
      grado_c = false
      grado_sstd = false
    elsif group_b > 4
      grado_a = false
      grado_b = false
    elsif group_b > 3
      grado_a = false
    end

    if group_a > 1
      grado_a = false
      grado_b = false
      grado_c = false
      grado_sstd = false
    end

    if grado_a
      self.usda = :A
    elsif grado_b
      self.usda = :B
    elsif grado_c
      self.usda = :C
    elsif grado_sstd
      self.usda = :SSTD
    else
      self.usda = :no_califica
    end

  end

  def calculate_df07
    #FIXME test
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

  # Obtiene ultimas quantity muestras de daños del process
  def self.get_samples(process, responsable = nil)
    product_type = ProductType.find_by(name: process)
    damage_samples =  product_type.damage_samples.active.ord
    return damage_samples if !responsable
    damage_samples.where(responsable: responsable)
  end

  def self.get_recent_samples(process, responsable = nil)
    t = Rails.configuration.max_sample_hrs
    dam_samples = DamageSample.get_samples(process, responsable)
    dam_samples = dam_samples.where('damage_samples.created_at > ?', t.hours.ago)
  end

  def self.in_user_last_samples(sample, responsable, number, process = nil)
    pt = ProductType.find_by(name: process)
    samples = pt.damage_samples
    samples = samples.where(responsable: responsable)
    .where('damage_samples.created_at > ?', Rails.configuration.max_sample_hrs.hours.ago)
    samples = samples.order('damage_samples.created_at DESC').ids.first(number)
    # print samples
    ret = sample.id.in?(samples)
    return ret
  end

end
