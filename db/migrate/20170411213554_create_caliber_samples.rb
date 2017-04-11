class CreateCaliberSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :caliber_samples do |t|
      t.string :responsable
      t.references :element, foreign_key: true
      t.integer :fruits_per_pound
      t.references :caliber, foreign_key: true
      t.integer :fruits_in_sample
      t.integer :sample_weight

      t.timestamps
    end
  end
end
