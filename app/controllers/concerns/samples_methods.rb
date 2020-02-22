module SamplesMethods

  private
  # REtorna proceso["secado", "recepcion_seco", "calibrado", ""]
  def process_name
    #  NOTE MEthod also in helper
    controller = Rails.application.routes.recognize_path(request.path)[:controller]
    process = controller.split("/").first
  end

end
