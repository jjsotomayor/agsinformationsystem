class PagesController < ApplicationController
  # Controlador de acceso libre
  
  def home
    render :home_logged_in if @user = logged_user
  end

  # def home_quality_controls
  # end

  private

end
