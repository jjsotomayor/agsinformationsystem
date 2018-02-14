class ProductType < ApplicationRecord

  validates :name,  uniqueness: true, presence: true

  has_many :elements
  has_many :damage_samples, :through => :elements
  has_many :caliber_samples, :through => :elements
  has_many :humidity_samples, :through => :elements
  has_many :sorbate_samples, :through => :elements
  has_many :carozo_samples, :through => :elements

  # When implemented Group, Access separetely elements samples than groups samples
  has_many :elements_groups
  has_many :group_damage_samples, through: :elements_groups, source: :damage_samples
  has_many :group_caliber_samples, through: :elements_groups, source: :caliber_samples
  has_many :group_humidity_samples, through: :elements_groups, source: :humidity_samples

  # Metodos para hacer mas sencillo acceso a muestras through groups, elems
  # REcibe type == :group or :elem y retornan samples apropiadas al caso
  def dam_samples(type)
    if type == :group
      self.group_damage_samples
    elsif type == :elem
      self.damage_samples
    end
  end

  def cal_samples(type)
    if type == :group
      self.group_caliber_samples
    elsif type == :elem
      self.caliber_samples
    end
  end

  def hum_samples(type)
    if type == :group
      self.group_humidity_samples
    elsif type == :elem
      self.humidity_samples
    end
  end

  def self.find_by_process(process)
    pt_name = process == "recepcion_seco" ? "secado" : process
    find_by(name: pt_name)
  end

end
