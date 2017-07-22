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
    pp name
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
    html << "<td>" + sample.element.tag.to_s + "</td>"
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


end
