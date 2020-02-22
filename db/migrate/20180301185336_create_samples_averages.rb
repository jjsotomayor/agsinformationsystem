class CreateSamplesAverages < ActiveRecord::Migration[5.0]
  def change
    create_table :samples_averages do |t|
      t.references :element, foreign_key: true

      t.decimal :fruits_per_pound
      t.decimal :deviation
      t.integer :deviation_status

      t.decimal :humidity

      t.decimal :sorbate

      t.decimal  :carozo_percentage

      t.float :off_color_perc
      t.float :poor_texture_perc
      t.float :scars_perc
      t.float :end_cracks_perc
      t.float :skin_or_flesh_damage_perc
      t.float :fermentation_perc
      t.float :heat_damage_perc
      t.float :insect_injury_perc
      t.float :mold_perc
      t.float :dirt_perc
      t.float :foreign_material_perc
      t.float :vegetal_foreign_material_perc
      t.float :insect_infestation_perc
      t.float :decay_perc
      t.float :deshidratado_perc
      t.float :bolsa_de_agua_perc
      t.float :ruset_perc
      t.float :reventados_perc
      t.float :carozo_perc
      t.float :total_damages_perc

      t.integer :usda
      # t.integer :df07, null: false, default:0

      t.timestamps
    end
  end
end
