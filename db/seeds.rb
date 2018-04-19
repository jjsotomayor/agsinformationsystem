# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# HumiditySample.all.destroy_all
# Element.all.destroy_all
#  ProductType.all.destroy_all
#  Role.all.destroy_all
def create_roles
 ['admin', 'lector', 'jefe_calidad', 'jefe_bodega', 'op_bodega'].each do |role_name|
   Role.create!(name: role_name)
 end
end

def create_calibers
 # Caliber.all.destroy_all
 Caliber.create([
  {name:"20-30", minimum:0, maximum:30},
  {name:"30-40", minimum:30, maximum:40},
  {name:"40-50", minimum:40, maximum:50},
  {name:"50-60", minimum:50, maximum:60},
  {name:"60-70", minimum:60, maximum:70},
  {name:"70-80", minimum:70, maximum:80},
  {name:"80-90", minimum:80, maximum:90},
  {name:"90-100", minimum:90, maximum:100},
  {name:"100-110", minimum:100, maximum:110},
  {name:"110-120", minimum:110, maximum:120},
  {name:"120-130", minimum:120, maximum:130},
  {name:"130-144", minimum:130, maximum:145},
  {name:"145+", minimum:145, maximum:1000000}
  ])
end

def create_product_types
# NOTE Si dejo secado y recepcion sol como prduct distintps puedo personalizar condiciones de rechazo aceptacion.
  product_types = # products type / proceso
  [
    { name: "fresco", humidity_min: nil, humidity_max: nil} ,
    # { name: "recepcion_seco", humidity_min: nil, humidity_max: nil} ,
    { name: "secado", humidity_min: 16, humidity_max: 19} , # Es el unico que se puede almacenar desde 2 interfaces.
    { name: "calibrado", humidity_min: nil, humidity_max: 20} ,
    { name: "seam", humidity_min: nil, humidity_max: 22} ,
    { name: "cn", humidity_min: nil, humidity_max: 20} ,
    { name: "tsc", humidity_min: 29, humidity_max: 32} ,
    { name: "tcc", humidity_min: 31, humidity_max: 35} ,
  ]
  # NOTE: Como sera el comportamiento para las muestras de rec. de cancha relacionado con las de secado.
  # Procesos si se hacen juntos
  # Opciones:
  # Juntas: Las 2 como PT seco (namespace diferente). Se almacenan juntas y se veran las 2 en la misma interfaz.
  # Juntas: Las 2 como PT distinto (namespace diferente). Se almacenan juntas y se veran las 2 en la misma interfaz.

  # Probablemente ellos la tienen que ver separado, pero jefes juntos(simplemente podrian filtrar por tipo de secado para separarlas)
  # Numeracion ira para SECO INDEPENDIENTE SEA RECEPCION O SECADO
  # TODO: En SECADO LES MUESTRO LAS QUE SON PT mixto o horno!
  ProductType.create!(product_types)
end

def create_operations
  operaciones = [ # = PRocesos
    { name: "laboratorio"} ,
    { name: "fresco"} ,
    { name: "recepcion_seco"} ,
    { name: "secado"} , # Es el unico que se puede almacenar desde 2 interfaces.
    { name: "calibrado"} ,
    { name: "seam"} ,
    { name: "cn"} ,
    { name: "tsc"} ,
    { name: "tcc"}
  ]
  Operation.create!(operaciones)
end

def create_drying_methods
  ['horno', 'sol', 'mixto'].each do |dm|
    DryingMethod.create!(name: dm)
  end
end

def create_counts
 if Count.count == 0
   puts "Creando contadores:"
   ["secado", "calibrado", "seam", "cn", "tsc", "tcc"].each do |pt_name|
     # puts "    " + pt_name
     pt = ProductType.find_by!(name: pt_name)
     Count.create!(product_type: pt, sample_type:"damage_sample", counter:0)
     Count.create!(product_type: pt, sample_type:"caliber_sample", counter:0)
   end
   pt = ProductType.find_by!(name: "tsc")
   Count.create!(product_type: pt, sample_type:"carozo_sample", counter:0)
 end
end

def create_users_and_ips
  User.all.destroy_all
  UserControl.destroy_all

  User.create!(name:"Joaquin", last_name:"Soto", password:"123123", email: "jjsotomayor@uc.cl", confirmed_at: "2018-01-24 17:00:00")
  admin = User.create!(name:"admin", last_name:"admin", password:"123123", email: "joaquinsotomayorc@gmail.com", confirmed_at: "2018-01-24 17:00:00")
  admin.authorized = true
  admin.role_id = Role.find_by(name: 'admin').id
  admin.save!

  UserControl.create!(name:"joaquin", password:"123123")
  IpAddress.create(ip: "127.0.0.1")     # IP local
  IpAddress.create(ip: "190.9.57.115")  # IP programador
  IpAddress.create(ip: "186.9.3.244")  # IP programador
  IpAddress.create(ip: "190.9.57.118") # IP de Agrosol

  UserControl.all.each do |uc|
    op = Operation.order("RANDOM()").first
    UserControlAccess.create(user_control: uc, operation: op)
  end
end

def create_warehouses
  Warehouse.destroy_all
  wahehouses = [
    { name: "Bodega 5"},
    { name: "Bodega 6"},
    { name: "Bodega 9"},
    { name: "Bodega 4"},
    { name: "Bodega virtual"},
  ]
  Warehouse.create!(wahehouses)
end




  #usda = ['A', 'B', 'C', 'SSTD', 'no califica']
  # 100.times do
  #   rand(1)
  #   elem = Element.new(tag: rand(100000), lot: rand(1000), product_type_id: rand(5)+1, drying_method_id: rand(3)+1)
  #   if !elem.save
  #     pp elem.errors
  #   end
  # end

  # u = User.last.confirmed_at =  "2018-01-24 17:00:00"
  # u.save
  # confirmed_at: "2018-01-24 17:00:00",
  # role_id: 1,# ADMIN Role.find_by(name: 'admin').id,#Role.where(name: "admin"),
  # authorized: true,


    # Cuando necesita crear varias samples
    # for i in 10000...12000 do
    #   e = Element.create(tag: i, product_type_id: 7)
    #   DamageSample.create!(element: e, responsable: "Juan_Diego", sample_weight: 1000, off_color: 55)
    # end

    create_roles
    create_calibers
    create_product_types if Rails.env != "test"
    create_operations
    create_drying_methods if Rails.env != "test"
    create_counts
    create_users_and_ips if Rails.env != "test"
    create_warehouses if Rails.env != "test"
