class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # helper da acceso a los metodos en las vistas e include en los controladores.
  helper TimeHelper
  # helper ViewsHelper
  helper SessionsHelper
  include SessionsHelper
  include IconsHelper

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :last_name])
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :last_name]) #same but for update

  end
end
