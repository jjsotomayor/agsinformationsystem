class UserControl < ApplicationRecord

  has_many :user_control_accesses, dependent: :destroy
  has_many :operations, through: :user_control_accesses
  # has_many :delivery_restrictions, { through: :category_delivery_restrictions }



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

  # Permite agregar un acceso en el menu al usuario control
  def add_access(operation_id)
    access = UserControlAccess.new(user_control: self, operation_id: operation_id)
    access.save
  end

  # Permite quitarle un acceso en el menu al usuario control
  def remove_access(operation_id)
    access = UserControlAccess.find_by(user_control: self, operation_id: operation_id)
    access.destroy
  end

  def has_access_to?(operation_name)
    self.operations.find_by(name: operation_name.downcase)
  end

end
