module Util
# Modulo creado para tener funciones globales

  # Retorna lista de daños para un proceso /producto especifico
  def self.damages_of_product_type(process)
    process = :none if !process
    process = "calibrado" if process == "seam" or process == "cn"
    damages =
    {
      none: [],
      all: [
        "off_color", "poor_texture", "scars", "end_cracks",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
        "vegetal_foreign_material", "insect_infestation", "decay",
        "deshidratado", "bolsa_de_agua", "ruset", "reventados", "carozo"
      ],
      fresco: [
        "scars", "mold", "decay", "deshidratado",
        "bolsa_de_agua", "ruset", "reventados"
      ],
      calibrado: [
        "off_color", "poor_texture", "scars",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
         "insect_infestation", "decay"
      ],
      "recepcion seco": [
        "off_color", "poor_texture", "scars", "skin_or_flesh_damage",
        "fermentation", "heat_damage", "insect_injury", "mold", "dirt",
        "foreign_material", "insect_infestation", "decay"
      ],
      secado: [
        "off_color", "poor_texture", "scars", "skin_or_flesh_damage",
        "fermentation", "heat_damage", "insect_injury", "mold", "dirt",
        "foreign_material", "insect_infestation", "decay"
      ],
      tsc: [
        "off_color", "poor_texture", "scars", "end_cracks",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
        "vegetal_foreign_material", "insect_infestation", "decay", "carozo"
      ],
      tcc: [
        "off_color", "poor_texture", "scars", "end_cracks",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
        "vegetal_foreign_material", "insect_infestation", "decay"
      ],
    }
    damages[process.to_sym]
  end

  ##########################################
  ## Metodos para calcular USDA y DF07    ##
  ##########################################

  # Todos reciben la muestra y generan la suma
  # inc quiere decir que genera la suma incremental necesaria para obtener el valor
  def self.usda_inc_b(s)
    porc = s.mold_perc + s.dirt_perc + s.foreign_material_perc
    + s.vegetal_foreign_material_perc + s.insect_infestation_perc
  end

  def self.usda_inc_c(s)
    porc = s.scars_perc + s.skin_or_flesh_damage_perc + s.fermentation_perc
    + s.heat_damage_perc + s.insect_injury_perc
  end
  def self.usda_inc_d(s)
    porc = s.end_cracks_perc
  end
  def self.usda_inc_e(s)
    porc = s.poor_texture_perc
  end
  def self.usda_inc_f(s)
    porc = s.off_color_perc
  end

  def self.df07_g1(s)
    porc = s.off_color_perc + s.poor_texture_perc
  end

  def self.df07_g2(s)
    porc = s.end_cracks_perc
  end

  def self.df07_g3(s)
    porc = s.skin_or_flesh_damage_perc + s.heat_damage_perc + s.insect_injury_perc
  end

  def self.df07_g4(s)
    porc = s.fermentation_perc
  end

  def self.df07_g5(s)
    porc = s.vegetal_foreign_material_perc
  end

  def self.df07_g6(s)
    porc = s.decay_perc + s.mold_perc
  end

  def self.df07_g7(s)
    porc = s.insect_infestation_perc
  end

  def self.df07_g7(s)
    porc = s.insect_infestation_perc
  end

end
