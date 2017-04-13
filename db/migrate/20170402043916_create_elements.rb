class CreateElements < ActiveRecord::Migration[5.0]
  def change
    create_table :elements do |t|
      t.string :tag, null: false, unique: true
      t.string :lot
      t.string :process_order
      t.references :product_type, foreign_key: true
      t.references :drying_method, foreign_key: true
      t.integer :previous_usda
      t.string :ex_tag

      t.timestamps
    end
  end
end
