class DamageSample < ApplicationRecord
  include SoftDeletable
  include Methods
  enum usda: [:A, :B, :C, :SSTD, :no_califica]
  enum df07: [:rechazado, :aprobado]

  belongs_to :element

  before_validation :calculate_percentages
  before_validation :calculate_usda
  before_validation :calculate_df07

  validates :element, :responsable, :sample_weight, :usda, presence: true
  validates :sample_weight, numericality: true


  def calculate_percentages
    self.attributes.each do |attr_name, attr_value|
      # NOTE Programa se caera si se crea atributo que termina en _perc para otra cosa
      calculate_one_percentage (attr_name) if attr_name.to_s.end_with? "perc"
    end
  end

  def calculate_usda
    # FIXME
    self.usda = :no_califica
  end

  def calculate_df07
    # FIXME
    self.df07 = :rechazado
  end

  # Para cada atributo _porc calcula su porcentaje o lo deja en nil
  def calculate_one_percentage (attr_percentage_name)
    grams = self.send(attr_percentage_name[0...-5])
    if grams
      percentage = (grams * 100)/ self.sample_weight
      self.send("#{attr_percentage_name}=", percentage)
    end
  end

end
