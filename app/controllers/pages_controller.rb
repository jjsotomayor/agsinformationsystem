class PagesController < ApplicationController
  def home
    render :home_logged_in if @user = logged_user
  end

  def home_quality_controls
  end

end
