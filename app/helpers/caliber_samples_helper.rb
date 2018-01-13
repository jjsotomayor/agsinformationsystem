module CaliberSamplesHelper

  def field_sample_weight(form)
    form.number_field :sample_weight, value: 454, readonly: true
  end

  def field_big_fruits_in_sample(type, cal_sample)
    value = type == "edit" ? cal_sample.deviation_sample.big_fruits_in_sample : ""
    number_field_tag :big_fruits_in_sample, value,  placeholder: ' cantidad en 283g', min:0
  end

  def field_small_fruits_in_sample(type, cal_sample)
    value = type == "edit" ? cal_sample.deviation_sample.small_fruits_in_sample : ""
    number_field_tag :small_fruits_in_sample, value, placeholder: ' cantidad en 283g', min:0
  end

end
