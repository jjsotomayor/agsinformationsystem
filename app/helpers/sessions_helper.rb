# frozen_string_literal: true

module SessionsHelper
  # current_user es el metodo provisto por devise

  # Returns the current user. nil if no user is logged
  def logged_user
    return current_user if current_user
    if session[:user_id] and session[:user_type] == "UserControl"
      puts session[:user_type]
      # NOTE: No es muy eficiente. busca el usuario en la base de datos cada vez que se llama
      return UserControl.find(session[:user_id])
    end
    return nil
  end

  def create_session_user_control(user)
    session[:user_id] = user.id
    session[:user_type] = user.class.name
    puts "Logueado usuario #{session[:user_type]}"
  end

  # Returns the class of the current user
  def user_type
    return session[:user_type] if session[:user_type]
    # return logged_user.class.name if logged_user
  end

  #Destroy session, returns true if successfull, msg if not
  def get_destroy_session_path
    if current_user
      return "/users/sign_out"
    elsif session[:user_id] and session[:user_type] == "UserControl"
      return "/user_controls/sign_out"
    end
  end

end
