class CreateCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :counts do |t|
      t.string :sample_type, null: false
      t.references :product_type, foreign_key: true, null: false
      t.integer :counter

      t.timestamps
    end

    add_index :counts, [:sample_type, :product_type_id], unique: true

  end
end
