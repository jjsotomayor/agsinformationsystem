module CaliberSamplesHelper

  # Si no se es ninguno de los usuarios, no habrá link
  def link_back_from_show_caliber(user_type)
    pp process_name
    if user_type == "User"
      link_to 'Atrás', send(process_name + "_caliber_samples_path"),  class: "btn btn-primary btn-xs"
    elsif user_type == "UserControl"
      link_to 'Atrás', send("new_" + process_name + "_caliber_sample_path"),  class: "btn btn-primary btn-xs"

    end
  end


end
