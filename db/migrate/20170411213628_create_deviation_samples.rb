class CreateDeviationSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :deviation_samples do |t|
      t.references :caliber_sample, foreign_key: true
      t.integer :big_fruits_in_sample
      t.integer :small_fruits_in_sample
      t.integer :sample_weight
      t.decimal :big_fruits_per_pound
      t.decimal :small_fruits_per_pound
      t.decimal :deviation, null: false

      t.integer :status, null: false, default:0
      t.boolean :status_modified, null: false, default:false

      t.timestamps
    end
  end
end
