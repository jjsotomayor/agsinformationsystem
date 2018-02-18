module ElementsGroupsHelper



  def link_to_remove_element(elem)
    tag = elem.tag
    # NO se pueden pasar form parameters, para eso es necesario crear form
    link_to 'X', remove_element_elements_group_path(tag: tag), method: :post,
            data: {confirm: "¿Seguro que deseas eliminar tarja #{tag}?" }, class: "btn btn-danger btn-xs"
  end

  def field_elements_group(f, type, class_type, sample)
    # value = type == "new" ? 0 : sample.elements_group.id
    @groups = ElementsGroup.all.order('id DESC')
    if type == "new"
      f.select :elements_group_id,  options_for_select(@groups.map{
        |eg| [eg.first_tag + '-' + eg.last_tag + " (" +eg.elements.count.to_s + ")" ,eg.id]}), {include_blank: true}, {class: class_type}
    else
      group = sample.elements_group
      text = group.first_tag + '-' + group.last_tag + " (" +group.elements.count.to_s + ")"
      f.text_field :elements_group_id, value: text, class: class_type, disabled: true#(type == 'edit')
    end
  end


  def field_first_tag(f, type)
    f.text_field :first_tag, autocomplete: 'off', disabled: (type == 'edit')
  end

  def field_last_tag(f, type)
    f.text_field :last_tag, autocomplete: 'off', disabled: (type == 'edit')
  end

  def group_link(group)
    link_text = group.first_tag + " --> " + group.last_tag
    link_to link_text, group,  class: "btn btn-element btn-xs"
  end

end
