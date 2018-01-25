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
    link_to 'Ver', send(product_type + "_" + sample_type + "_path", sample),  class: "btn btn-primary btn-xs"
  end

  def link_edit_sample(sample, sample_type, product_type)
    link_to 'Editar', send("edit_" + product_type + "_" + sample_type + "_path", sample), class: "btn btn-warning btn-xs"
  end

  def link_delete_sample(sample, sample_type, product_type)
    link_to 'Eliminar', send(product_type + "_"+ sample_type + "_path", sample), method: :delete, data: { confirm: '¿Seguro que deseas eliminar la muestra?' }, class: "btn btn-danger btn-xs"
  end

end
