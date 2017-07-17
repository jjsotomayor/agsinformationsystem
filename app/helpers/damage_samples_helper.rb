module DamageSamplesHelper

  def get_form(process)
    # FIXME Cuando cambien los procesos, habra que sintonizar esto!
    # ensacado tiene mismos daños que calibrado
    process = "calibrado" if process == 'ensacado'
    "form_inputs_"+ process
  end

  # Retorna uno de los conjuntos de daños
  def get_damage_category(process)
    # FIXME Cuando cambien los procesos, habra que sintonizar esto!
    # ensacado tiene mismos daños que calibrado
    process = "calibrado" if process == 'ensacado'
    process
  end

end
