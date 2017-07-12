class CreateCaliberSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :caliber_samples do |t|
      t.string :responsable, null: false
      t.references :element, foreign_key: true
      t.integer :fruits_in_sample, null:false
      t.integer :sample_weight, null:false
      t.integer :fruits_per_pound, null:false
      t.references :caliber, foreign_key: true

      t.timestamps
    end
  end
end
