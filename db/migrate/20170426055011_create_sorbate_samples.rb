class CreateSorbateSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :sorbate_samples do |t|
      t.references :element, foreign_key: true
      t.string :responsable, null: false
      t.decimal :sorbate, null: false
      t.integer :state, null: false, default:0
      t.boolean :state_revised, null: false, default:false

      t.timestamps
    end
  end
end