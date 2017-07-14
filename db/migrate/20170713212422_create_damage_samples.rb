class CreateDamageSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :damage_samples do |t|
      t.string :responsable
      t.references :element, foreign_key: true
      t.decimal :sample_weight
      t.float :off_color
      t.float :off_color_perc
      t.float :poor_texture
      t.float :poor_texture_perc
      t.float :scars
      t.float :scars_perc
      t.float :end_cracks
      t.float :end_cracks_perc
      t.float :skin_or_flesh_damage
      t.float :skin_or_flesh_damage_perc
      t.float :fermentation
      t.float :fermentation_perc
      t.float :heat_damage
      t.float :heat_damage_perc
      t.float :insect_injury
      t.float :insect_injury_perc
      t.float :mold
      t.float :mold_perc
      t.float :dirt
      t.float :dirt_perc
      t.float :foreign_material
      t.float :foreign_material_perc
      t.float :vegetal_foreign_material
      t.float :vegetal_foreign_material_perc
      t.float :insect_infestation
      t.float :insect_infestation_perc
      t.float :decay
      t.float :decay_perc
      t.float :deshidratado
      t.float :deshidratado_perc
      t.float :bolsa_de_agua
      t.float :bolsa_de_agua_perc
      t.float :ruset
      t.float :ruset_perc
      t.float :reventados
      t.float :reventados_perc

      t.integer :usda, null: false
      t.boolean :df07, null: false, default:false

      t.boolean :active, null: false, default:true
      t.datetime :deleted_at


      t.timestamps
    end
  end
end
