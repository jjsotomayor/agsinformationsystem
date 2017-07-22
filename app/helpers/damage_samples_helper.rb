module DamageSamplesHelper

  # def get_form(process)
  #   # FIXME Cuando cambien los procesos, habra que sintonizar esto!
  #   # ensacado tiene mismos daños que calibrado
  #   process = "calibrado" if process == 'ensacado'
  #   "form_inputs_"+ process
  # end

  # Retorna uno de los conjuntos de daños
  # def get_damage_category(process)
  #   # FIXME Cuando cambien los procesos, habra que sintonizar esto!
  #   # ensacado tiene mismos daños que calibrado
  #   process = "calibrado" if process == 'ensacado'
  #   process
  # end

  def translate_damage(damage)
    translation = {
      "off_color":	"Fuera de color",
      "poor_texture":	"Textura deficiente",
      "scars":	"Cicatrices",
      "end_cracks":	"Cola",
      "skin_or_flesh_damage":	"Daño piel o pulpa",
      "fermentation":	"Fermentacion",
      "heat_damage":	"Daño por calor",
      "insect_injury":	"Daño por insectos",
      "mold":	"Hongo",
      "dirt":	"Suciedad adherida",
      "foreign_material":	"Materias extrañas",
      "vegetal_foreign_material":	"Materia ext vegetal",
      "insect_infestation":	"Infestac insectos",
      "decay":	"Pudricion",
      "deshidratado": "Deshidratado",
      "bolsa_de_agua": "Bolsa de agua",
      "ruset": "Ruset",
      "reventados": "Reventados",
      "carozo": "Carozo"
    }
    translation[damage.to_sym]
  end



  #####################
  #TODO Metodos son sobrescritodos por helpers especificos de c/proceso
  #####################
  def table_headers_damages(type)
    html = ""
    @damages_list.each do |dam|
      html << "<th>" + translate_damage(dam)+type+ "</th>"
    end
    html.html_safe
  end

  # Retorn los daños como porcentaje o gramos, ademas permite incluir (% o g) si type = "%" o "g"
  def table_body_damages(damage_sample, type = "", include_sign = false)
    attr_end = type.include?("%") ? "_perc" : ""
    pp "agregar: #{attr_end}"
    type = "" unless include_sign
    html = ""
    @damages_list.each do |dam|
      html << "<td>" + concat_if_not_empty(round_or_nil(damage_sample.send(dam + attr_end)).to_s, type) + "</td>"
    end
    html.html_safe
  end

  ##########################################
  ############## Links helpers ############
  ##########################################

  # Si no se es ninguno de los usuarios, no habra link
  def link_back_from_show(user_type)
    process_name
    if user_type == "User"
      link_to 'Atrás', send(process_name + "_damage_samples_path")#secado_damage_samples_path
    elsif user_type == "UserControl"
      link_to 'Atrás', send("new_" + process_name + "_damage_sample_path")#new_secado_damage_sample_path
    end
  end

end
