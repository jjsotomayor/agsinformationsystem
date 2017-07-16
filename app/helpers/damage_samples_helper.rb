module DamageSamplesHelper

  def get_form(process)
    # ensecado usa en name de calibrado
    process == "calibrado" if process == "ensecado"
    "form_inputs_"+ process
  end
end
