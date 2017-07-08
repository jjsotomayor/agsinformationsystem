class UserControl < ApplicationRecord

  def self.create_session(name, password)
    response = {msg: ""}
    user = UserControl.find_by(name: name)
    if !user
      response[:status] = "error"
      response[:msg] = "Nombre de usuario incorrecto"
    elsif user.password != password
      response[:status] = "error"
      response[:msg] = "Clave incorrecta"
      puts "CLAVE INCORRECTA"
    else
      # user.initiate_session(user)
      response[:status] = "ok"
      response[:user] = user 
    end
    response
  end

  # def initiate_session
  #   session[:user] = user
  #   session[:user_id] = user.id
  # end

end
