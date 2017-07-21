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
      "vegetal_foreign_material":	"Materia extraña vegetal",
      "insect_infestation":	"Infestac insectos",
      "decay":	"Pudricion",
      "deshidratado": "Deshidratado",
      "bolsa_de_agua": "Bolsa de agua",
      "ruset": "Ruset",
      "reventados": "Reventados"
    }
    translation[damage.to_sym]
  end





  ##########################################
  ######### METHODS USED IN THE FORM #######
  ##########################################
  def set_url_for_form(type, sample) # , process
    # TODO Movible a algo mas general! (Helper para todas las samples)
    # Obtiene process actual de la url!
    process = controller.class.parent.to_s.downcase
    if type == "new"
      # Arma el string y con send llama al path/url helper autogenerado para las rutas de la app
      url = send(process + "_" + controller_name + "_path")
    elsif type == "edit"
      puts "ID: #{sample.id.to_s}"
      url = "/"+process + "/" + controller_name + "/"+ sample.id.to_s
      puts url
      url
    end
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
  def table_body_damages(damage_sample, type = "", include_sign)
    attr_end = type.include?("%") ? "_perc" : ""
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
    if user_type == "User"
      link_to 'Atrás', secado_damage_samples_path
    elsif user_type == "UserControl"
      link_to 'Atrás', new_secado_damage_sample_path
    end
  end

end
