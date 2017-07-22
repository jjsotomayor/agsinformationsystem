module Util
# Modulo creado para tener funciones globales

  # Retorna lista de daños para un proceso /producto especifico
  def self.damages_of_product_type(process)
    process = "calibrado" if process == "seam" or process == "cn"
    damages =
    {
      all: [
        "off_color", "poor_texture", "scars", "end_cracks",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
        "vegetal_foreign_material", "insect_infestation", "decay",
        "deshidratado", "bolsa_de_agua", "ruset", "reventados"
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
      recepcion_seco: [
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


end
