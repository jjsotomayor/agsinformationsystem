# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


 Role.all.destroy_all
 ['admin', 'jefe_planta', 'jefe_control_calidad', 'jefe_bodega'].each do |role_name|
   Role.create!(name: role_name)
 end

 Caliber.all.destroy_all
 Caliber.create([
  {name:"20-30", minimum:20, maximum:30},
  {name:"30-40", minimum:30, maximum:39},
  {name:"40-50", minimum:40, maximum:49},
  {name:"50-60", minimum:50, maximum:59},
  {name:"60-70", minimum:60, maximum:69},
  {name:"70-80", minimum:70, maximum:79},
  {name:"80-90", minimum:80, maximum:89},
  {name:"90-100", minimum:90, maximum:99},
  {name:"100-110", minimum:100, maximum:109},
  {name:"110-120", minimum:110, maximum:119},
  {name:"120-130", minimum:120, maximum:129},
  {name:"130-144", minimum:130, maximum:144},
  {name:"145+", minimum:145, maximum:1000}
  ])



 ['fresco', 'seco', 'calibrado', 'TCC', 'TSC'].each do |pt|
   ProductType.create!(name: pt)
 end

 ['horno', 'sol', 'mixto'].each do |dm|
   DryingMethod.create!(name: dm)
 end

 User.all.destroy_all
 User.create!(name:"Joaquin", last_name:"Soto", password:"123456789", email: "jjsotomayor@uc.cl")

#usda = ['A', 'B', 'C', 'SSTD', 'no califica']
HumiditySample.all.destroy_all
Element.all.destroy_all
100.times do
  rand(1)
  Element.create!(tag: rand(100000), lot: rand(1000), process_order: rand(100), product_type_id: rand(5)+1, drying_method_id: rand(3)+1, previous_usda: rand(0..4))
end
