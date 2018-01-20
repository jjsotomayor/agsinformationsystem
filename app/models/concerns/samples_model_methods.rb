module SamplesModelMethods
  # Modulo que permite que las samples que  inciden en el color, cada vez q
  # se creen modifiquen o eliminen, se actualice el color de element
  extend ActiveSupport::Concern

  included do
   after_destroy :refresh_element_color
   after_update :refresh_element_color
   after_save :refresh_element_color
  end

  def refresh_element_color
    elem = self.element
    logger.info {"Revisando si se actualizan colores de element #{elem.tag}!!!"}
    if elem.all_samples_taken?
      elem.calculate_color
    # Revisa de inmediato Humedad y Sorbato pq son motivo de color rojo (rechazo)
    elsif elem.product_type
      elem.check_if_red_humidity_color if elem.humidity_samples.count > 0
      elem.check_if_red_sorbate_color if elem.sorbate_samples.count > 0
    end
  end

  # module ClassMethods
  # end


end
