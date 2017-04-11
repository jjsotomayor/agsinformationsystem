# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Role.all.destroy_all
#
# ['admin', 'gerente', 'jefe_planta', 'jefe_control_calidad', 'jefe_bodega'].each do |role_name|
#   Role.create!(name: role_name)
# end
#
# ['fresco', 'seco', 'calibrado', 'TCC', 'TSC'].each do |pt|
#   ProductType.create!(name: pt)
# end
#
# ['horno', 'sol', 'mixto'].each do |dm|
#   DryingMethod.create!(name: dm)
# end
#
# User.create!(name:"Joaquin", last_name:"Soto", password:"123456789", email: "jjsotomayor@uc.cl")

usda = ['A', 'B', 'C', 'SSTD', 'no califica']
10000.times do
  rand(1)
  Element.create!(tag: rand(1000000000), lot: rand(1000), process_order: rand(100), product_type_id: rand(5)+1, drying_method_id: rand(3)+1, previous_usda: usda[rand(4)+1])
end
