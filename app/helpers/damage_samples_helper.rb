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

  # NOTE Comentado porque se paso al lib/utilities
  # def translate_damage(damage)
  #   translation = {
  #     "off_color":	"Fuera de color",
  #     "poor_texture":	"Textura deficiente",
  #     "scars":	"Cicatrices",
  #     "end_cracks":	"Cola",
  #     "skin_or_flesh_damage":	"Daño piel o pulpa",
  #     "fermentation":	"Fermentacion",
  #     "heat_damage":	"Daño por calor",
  #     "insect_injury":	"Daño por insectos",
  #     "mold":	"Hongo",
  #     "dirt":	"Suciedad adherida",
  #     "foreign_material":	"Materias extrañas",
  #     "vegetal_foreign_material":	"Materia ext vegetal",
  #     "insect_infestation":	"Infestac insectos",
  #     "decay":	"Pudricion",
  #     "deshidratado": "Deshidratado",
  #     "bolsa_de_agua": "Bolsa de agua",
  #     "ruset": "Ruset",
  #     "reventados": "Reventados",
  #     "carozo": "Carozo"
  #   }
  #   translation[damage.to_sym]
  # end



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
    # pp "agregar: #{attr_end}"
    type = "" unless include_sign
    html = ""
    @damages_list.each do |dam|
      html << "<td>" + concat_if_not_empty(round_or_nil(damage_sample.send(dam + attr_end)).to_s, type) + "</td>"
    end
    html.html_safe
  end

  ##################################################################
  ### Metodos q permiten renderear creacion/edicion de datos de  ###
  ### element en new/edit damage_samples (type = "new"/"edit")   ###
  ##################################################################


  # def field_process_order(type, class_type, dam_sample)
  #   value = type == "new" ? '' : dam_sample.element.process_order
  #   text_field_tag :process_order, value, class: class_type, autocomplete: 'off'
  # end

  def field_lot(type, class_type, dam_sample)
    value = type == "new" ? '' : dam_sample.element.lot
    text_field_tag :lot, value, class: class_type, autocomplete: 'off'
  end

  def field_drying_method_id(type, class_type, dam_sample)
    @d_methods = DryingMethod.all
    @d_methods = @d_methods.where.not(name: "sol") if @process == "secado"

    value = type == "new" ? 0 : dam_sample.element.drying_method_id
    select_tag "drying_method_id",  options_for_select(@d_methods.map{|dm| [dm.name,dm.id]}, value), include_blank: true, class: class_type
  end

  def field_first_item(type, class_type, dam_sample)
    value = type == "new" ? '' : dam_sample.element.first_item
    text_field_tag :first_item, value, class: class_type, placeholder: "Ingreso único", autocomplete: 'off'
  end

  def field_last_item(type, class_type, dam_sample)
    value = type == "new" ? '' : dam_sample.element.last_item
    text_field_tag :last_item, value, class: class_type, placeholder: "Ingreso único", autocomplete: 'off'
  end

  def field_ex_tag(type, class_type, dam_sample)
    value = type == "new" ? '' : dam_sample.element.ex_tag
    text_field_tag :ex_tag, value, class: class_type
  end

  def field_previous_color(type, class_type, dam_sample)
    value = type == "new" ? 0 : dam_sample.element.previous_color
    select_tag :previous_color,  options_for_select([:azul, :verde, :amarillo, :rojo], value), include_blank: true, class: class_type
  end


  #####################################
  ###      Generacion de links      ###
  ##################################### (Implementar idem para caliberSample)

  # Se puede utilizar para Show y Delete
  def link(process, damage_sample)
    send(process + "_damage_sample_path", damage_sample)
  end

  # Genera el link para edición, considera que es posible que link lleve a descarte
  def edit_link(process, damage_sample)
    process = "descarte" if damage_sample.element.descarte
    send("edit_" + process +"_damage_sample_path", damage_sample)
  end


end
