ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include Warden::Test::Helpers

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

def prepare_all(role = :admin)
  setup_db()
  if role == :control
    login_user_control
  else
    @user = get_user(role)
    login_as(@user)
  end
end

def setup_db
  # t1 = Time.now
  Rails.application.load_seed
  # t2 = Time.now
  # puts "Diferencia = #{t2-t1}"
end

def get_user(role)
  @role = Role.find_by(name: role)#(name: 'admin')
  @admin = User.create!(email: "admin@mail.com", name: 'Pablo', last_name: 'Alvarado',
    confirmed_at: "2018-01-24 17:00:00",
    role_id: @role.id,# ADMIN Role.find_by(name: 'admin').id,#Role.where(name: "admin"),
    authorized: true,
    password: Devise::Encryptor.digest(User, "helloworld"))
end

def login_user_control
  #NOTE Se testeara con un UserControl que es creador de todas las muestras!
  @user = user_controls(:one)
  post user_controls_create_session_path, params: {name: @user.name, password: @user.password}
end

def set_element_product_type(sample, process)
  elem = sample.element
  elem.update(product_type: ProductType.find_by(name: process))
end

def processes_available(process)
  # TODO Falta recepcion seco
  processes = {
    humidity: ["tsc", "tcc", "secado", "cn", "seam", "calibrado"],
    sorbate: ["tsc", "tcc"],
  }
  processes[process.to_sym]
end

def params_humidity(humidity_sample)
  {
    humidity_sample:
      {humidity: humidity_sample.humidity, responsable: humidity_sample.responsable},
    tag: humidity_sample.element.tag
  }
end

def params_sorbate(sorbate_sample)
  {
    sorbate_sample:
      {sorbate: sorbate_sample.sorbate,responsable: sorbate_sample.responsable},
    tag: sorbate_sample.element.tag
  }
end

def params_caliber_sample(dev_sample = false)
  params = {
    caliber_sample: {responsable: "person", fruits_in_sample: 62, sample_weight: 454},
    tag:"example_tag"
  }
  if dev_sample
    params = params.merge({big_fruits_in_sample: 30, small_fruits_in_sample: 60})
  end
  params
end

def params_damage_sample(process, sample)
  dry_method = drying_methods(random("dm", 1, 3))
  ds_params = {responsable: "Joaq", sample_weight: 100}
  elem_params = {tag: sample.element.tag, drying_method_id: dry_method.id}

  elem_params = elem_params.merge(lot: "lote") if process.in?(["recepcion", "secado", "calibrado"])
  if process.in?(["tsc", "tcc"])
    add = {first_item: 15000, last_item: 15100, ex_tag: "tsc 123", previous_color: "azul"}
    elem_params = elem_params.merge(add)
  end
  # Aqui se añaden los daños directamente
  Util.damages_of_product_type(process).each do |dam|
    ds_params[dam.to_s] = rand(0..1)
  end
  params = {damage_sample: ds_params}.merge(elem_params)
end

# REtorna un fixture aleatorio entre textfirst y tesxtlast
def random(text, first, last)
  value = rand(first..last)
  selected = text + value.to_s
  puts "Selected: " + selected
  selected.to_sym
end


def damage_sample_of_different_process(process)
  picked_process = ([:secado, :calibrado, :seam, :cn, :tsc, :tcc]- [process]).sample
  damage_samples(picked_process)
end

def caliber_sample_of_different_process(process)
  picked_process = ([:secado, :calibrado, :seam, :cn, :tsc, :tcc]- [process]).sample
  caliber_samples(picked_process)
end

def random_process(except = nil)
  ([:secado, :calibrado, :seam, :cn, :tsc, :tcc]-[except]).sample
end
