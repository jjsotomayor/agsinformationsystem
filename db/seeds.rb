# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# HumiditySample.all.destroy_all
# Element.all.destroy_all
#  ProductType.all.destroy_all
#  Role.all.destroy_all

 ['admin', 'jefe_planta', 'jefe_control_calidad', 'jefe_bodega'].each do |role_name|
   Role.create!(name: role_name)
 end

 # Caliber.all.destroy_all
 Caliber.create([
  {name:"20-30", minimum:20, maximum:30},
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
  {name:"145+", minimum:145, maximum:1000}
  ])

# NOTE Si dejo secado y recepcion sol como prduct distintps puedo personalizar condiciones de rechazo aceptacion.
product_types = # products type / proceso
  [
    { name: "fresco", humidity_min: nil, humidity_max: nil} ,
    { name: "recepcion seco", humidity_min: nil, humidity_max: nil} ,
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

 ['horno', 'sol', 'mixto'].each do |dm|
   DryingMethod.create!(name: dm)
 end

 User.all.destroy_all
 UserControl.destroy_all

 User.create!(name:"Joaquin", last_name:"Soto", password:"123123", email: "jjsotomayor@uc.cl")
 UserControl.create!(name:"joaquin", password:"123123")
 IpAddress.create(ip: "127.0.0.1")


  #usda = ['A', 'B', 'C', 'SSTD', 'no califica']
  # 100.times do
  #   rand(1)
  #   elem = Element.new(tag: rand(100000), lot: rand(1000), process_order: rand(100), product_type_id: rand(5)+1, drying_method_id: rand(3)+1, previous_usda: rand(0..4))
  #   if !elem.save
  #     pp elem.errors
  #   end
  # end

  UserControl.all.each do |uc|
    pt = ProductType.order("RANDOM()").first
    UserControlAccess.create(user_control: uc, product_type: pt)
  end
