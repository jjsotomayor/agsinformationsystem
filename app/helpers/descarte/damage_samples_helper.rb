module Descarte::DamageSamplesHelper

  def field_product_type(type, class_type, dam_sample)
    # select_tag "product_type_id",  options_for_select(ProductType.all.map{|pt| [pt.name,pt.id]}, 0),
    value = type == "new" ? 0 : dam_sample.element.product_type.name
    select_tag "product_type",  options_for_select(ProductType.all.pluck(:name), value),include_blank: true, class: class_type
  end

end
