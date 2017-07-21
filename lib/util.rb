module Util
# Modulo creado para tener funciones globales

  # Retorna lista de daños para un proceso /producto especifico
  def self.damages_of_product_type(process)
    damages =
    {
      "secado": [
        "off_color", "poor_texture", "scars", "skin_or_flesh_damage",
        "fermentation", "heat_damage", "insect_injury", "mold", "dirt",
        "foreign_material", "insect_infestation",
        "decay"
      ]
    }
    damages[process.to_sym]
  end


end
