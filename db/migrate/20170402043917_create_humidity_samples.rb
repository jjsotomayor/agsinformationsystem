class CreateHumiditySamples < ActiveRecord::Migration[5.0]
  def change
    create_table :humidity_samples do |t|
      t.references :element, foreign_key: true
      t.string :responsable, null: false
      t.decimal :humidity, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
