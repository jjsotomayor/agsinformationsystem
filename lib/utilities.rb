module Utilities
# Metodos generales usados en muchos lugares, hacer require antes de usarlos

  #Redondea a n decimal, o retorna nil
  def round_or_nil(value, n = 1)
    value.round(n) if value
  end
  # Mismo metodo de arriba, pero bieen
  def round_nil_safe(value, n = 1)
    value.round(n) if value
  end

  # Between, but requires min and max inputs
  def between_min_max?(value, min, max) # TODO Repetido en concern/Methods
    return true if value >= min and value <= max
    return false
  end

  def translate_damage(damage)
    translation = {
      "off_color":	"Fuera de color",
      "poor_texture":	"Textura deficiente",
      "scars":	"Cicatrices",
      "end_cracks":	"Cola",
      "skin_or_flesh_damage":	"Daño piel o pulpa",
      "fermentation":	"Fermentacion",
      "heat_damage":	"Vana", #{}"Daño por calor" Se deberia haber creado una nueva columna
      "insect_injury":	"Daño por insectos",
      "mold":	"Hongo",
      "dirt":	"Suciedad adherida",
      "foreign_material":	"Materias extrañas",
      "vegetal_foreign_material":	"Materia ext vegetal",
      "insect_infestation":	"Infestac insectos",
      "decay":	"Aplastada" ,#{}"Pudricion",
      "deshidratado": "Deshidratado",
      "bolsa_de_agua": "Bolsa de agua",
      "ruset": "Ruset",
      "reventados": "Reventados",
      "carozo": "Carozo"
    }
    translation[damage.to_sym]
  end

  # Imprime en corto el primer al ultimo item de un elemento "xxx- xxx"
  def first_last_item(element, with_space = true)
    # separation = with_space ? "- " : "-"
    ((element.first_item || "") + "- " + (element.last_item || ""))
  end

end
