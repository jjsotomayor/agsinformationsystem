class UserControl < ApplicationRecord

  def self.is_valid_login(name, password)
    response = {msg: ""}
    user = UserControl.find_by(name: name)
    if !user
      response[:status] = "error"
      response[:msg] = "Nombre de usuario incorrecto"
    elsif user.password != password
      response[:status] = "error"
      response[:msg] = "Contraseña incorrecta"
      puts "CLAVE INCORRECTA"
    else
      response[:status] = "ok"
      response[:user] = user
    end
    response
  end

end
