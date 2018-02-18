module ElementsHelper


  def first_last_item(element, with_space = true)
    # separation = with_space ? "- " : "-"
    ((element.first_item || "") + "- " + (element.last_item || ""))
  end

  ##################################################################
  ###################### Links  ####################################
  ##################################################################

  ### Links para usar en el show de elements ###
  def link_show_sample(sample, sample_type, product_type)
    #Example: tsc_damage_sample_path(damage_sample)
    process = get_process(sample, product_type)
    link_to 'Ver', send(process + "_" + sample_type + "_path", sample),  class: "btn btn-primary btn-xs"
  end

  def link_edit_sample(sample, sample_type, product_type)
    process = get_process(sample, product_type)
    link_to 'Editar', send("edit_" + process + "_" + sample_type + "_path", sample), class: "btn btn-warning btn-xs"
  end

  def link_delete_sample(sample, sample_type, product_type)
    process = get_process(sample, product_type)
    link_to 'Eliminar', send(process + "_"+ sample_type + "_path", sample), method: :delete, data: { confirm: '¿Seguro que deseas eliminar la muestra?' }, class: "btn btn-danger btn-xs"
  end

  # OBtiene el proceso, que es lo mismo que Pt, salvo que secado puede ser process rec_seco y secado
  def get_process(sample, product_type)
    return product_type if product_type != "secado"
    sample.group ? "recepcion_seco" : "secado"
  end

  def link_or_group_name(group)
    if access_link_to_groups
      group_link(group)
    else
      group.name
    end
  end

end
