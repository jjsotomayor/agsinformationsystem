class CreateSorbateSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :sorbate_samples do |t|
      t.references :element, foreign_key: true
      t.string :responsable, null: false
      t.decimal :sorbate, null: false
      t.integer :status, null: false, default:0
      t.boolean :status_modified, null: false, default:false

      t.timestamps
    end
  end
end
