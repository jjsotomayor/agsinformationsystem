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
    self.element.refresh_element_color
  end

  # module ClassMethods
  # end


end
