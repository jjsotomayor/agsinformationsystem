class UserControl < ApplicationRecord

  def self.is_valid_login(name, password, ip)
    response = {msg: ""}
    puts ip
    if !IpAddress.find_by(ip: ip)
      response[:status] = "error"
      response[:msg] = "Error. Punto de acceso no autorizado, solicite acceso al administrador"
      return response
    end

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
