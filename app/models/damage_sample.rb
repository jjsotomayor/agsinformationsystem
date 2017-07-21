class DamageSample < ApplicationRecord
  include SoftDeletable
  include Methods
  enum usda: [:A, :B, :C, :SSTD, :no_califica]
  enum df07: [:rechazado, :aprobado]

  belongs_to :element
  delegate :product_type, :to => :element, :allow_nil => true

  before_validation :calculate_percentages
  before_validation :calculate_usda
  before_validation :calculate_df07

  validates :element, :responsable, :sample_weight, :usda, presence: true
  validates :sample_weight, numericality: true


  def calculate_percentages
    total = 0
    Util.damages_of_product_type("all").each do |damage_name|
      total += calculate_one_percentage (damage_name)
    end
    self.total_damages = total
    self.total_damages_perc = (total.to_f * 100)/ self.sample_weight
  end

  # Para cada atributo _porc calcula su porcentaje o lo deja en nil
  def calculate_one_percentage (damage_name)
    grams = self.send(damage_name)
    if grams
      percentage = (grams * 100)/ self.sample_weight
      self.send("#{damage_name}_perc=", percentage)
    end
    grams || 0
  end

  def calculate_usda
    # FIXME
    self.usda = :no_califica
  end

  def calculate_df07
    # FIXME
    self.df07 = :rechazado
  end

  # Obtiene ultimas quantity muestras de daños del process
  def self.get_samples(process, responsable = nil)
    product_type = ProductType.find_by(name: process)
    damage_samples =  product_type.damage_samples.active.order('created_at DESC')
    return damage_samples if ! responsable
    damage_samples.where(responsable: responsable)
  end

end
