module ApplicationHelper

  #Redondea a n decimal, o retorna nil
  def round_or_nil(value, n = 1)
    value.round(n) if value
  end

  def str(string_value, type)
    string_value + type if string_value
    puts ""
  end

  def concat_if_not_empty(str1, str2)
    ret = ""
    ret = str1 + str2 if str1 != ""
    ret
  end

  # Retorna "selected" si se esta en el proceso, sino "". Para usar en css class
  def selected(process)
    return "selected" if process_name == process
    return ""
  end

  def is_laboratorio
    name = controller.class.name
    return "selected" if  name == "HumiditySamplesController" or name == "SorbateSamplesController"
    ""
  end


  ##########################################
  ############## HELPING TO RENDER #########
  ##########################################
  def common_table_headers
    html = #{}"<th>#</th>
            "<th>Resp.</th>
            <th>Tarja</th>
            <th>Peso muest. (gr)</th>"
    html.html_safe
  end

  def common_table_body(sample)
    #html =  {}"<td>" + sample.id.to_s + "</td>"
    html = "<td>" + sample.responsable.truncate(7) + "</td>"
    html << "<td>" + element_link(sample.element) + "</td>"
    html << "<td>" + round_or_nil(sample.sample_weight).to_s + "</td>"
    html.html_safe
  end

  # Rscibe el tipo de form (new, edit) y retorna si este debe tener metodo post o patch
  def set_form_method(type)
    method =  type == "new" ? 'post' : 'patch'
  end

  # Retorna el proceso actual. Corresponse al namespace padre del controlador
  def process_name
    controller.class.parent.to_s.downcase
  end


  def short_status(sample)
    if sample.aprobado?
      "Aprob."
    elsif sample.rechazado?
      "Rech."
    elsif sample.pendiente?
      "Pend."
    else
      "-"
    end
  end

  def element_link(element)
    link_to element.tag, element,  class: "btn btn-element btn-xs"
  end

  ##########################################
  ################ Diseño #################
  ##########################################
  # Recibe objeto muestra y retorna class de la fila en la tabla
  def colored_rows(sample)
    if sample.aprobado?
      "success"
    elsif sample.rechazado?
      "danger"
    elsif sample.pendiente?
      "warning"
    end
  end

  def color_row_yellow(boolean)
    boolean ? "warning" : ""
  end

  def colored_rows_with_color(color)
    colors = {
      azul: "info",
      verde: "success",
      amarillo: "warning",
      rojo: "danger",
      "-": "active"
      #NOTE: El active deberia ser "" y que por defecto muestre ese color
    }
    colors[color.to_sym]
  end

  def translate_color(color)
    colors = {
      azul: "blue",
      verde: "green",
      amarillo: "yellow",
      rojo: "red",
    }
    colors[color.to_sym] || ""
  end

  ##########################################
  ######### METHODS USED IN THE FORM #######
  ##########################################
  def set_url_for_form(type, sample)
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

  ##########################################
  ##########################################
  def navbar_user(user)
    role = user.role.name
    role = 'jefe_bodega' if role == 'op_bodega'
    'shared/navbar_' + role
  end

  ##########################################
  ###### Metodos de acceso a botones  ######
  ##########################################

  # Retorna true o false si se tiene o no acceso
  def access_edit_delete_sample_button # Usado en index
    role = get_role_or_nil
    return true if role.in?(['admin', 'jefe_calidad'])
    false
  end

  def access_edit_destroy_element_button
    role = get_role_or_nil
    return true if role.in?(['admin', 'jefe_calidad'])
    false
  end

  ##########################################
  ################## Fields  ###############
  ##########################################

  def field_tag(type, class_type, sample)
    value = type == "new" ? '' : sample.element.tag
    text_field_tag :tag, value, class: class_type, autocomplete: 'off'#, disabled: (type == 'edit')
  end


  ##########################################
  ############ Bodega render  ##############
  ##########################################

  # Recibe un element o un movement
  def banda_pos_altura_nil_safe(element)
    if element.warehouse
      banda = element.banda || ""
      pos = element.posicion || ""
      altura = element.altura || ""
      banda + ", " + pos + ", " + altura
    else
      ""
    end
  end

end
