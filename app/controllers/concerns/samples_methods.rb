module SamplesMethods

  private
  def process_name
    #  NOTE MEthod also in helper
    controller = Rails.application.routes.recognize_path(request.path)[:controller]
    process = controller.split("/").first
    pp process
  end

end
