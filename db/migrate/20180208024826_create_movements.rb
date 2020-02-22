class CreateMovements < ActiveRecord::Migration[5.0]
  def change
    create_table :movements do |t|
      t.references :element, foreign_key: true, null:false
      t.integer :movement_type, null:false
      t.integer :weight
      t.references :warehouse, foreign_key: true
      t.string :banda
      t.string :posicion
      t.string :altura
      t.string :warehouse_responsable, null:false
      t.string :destination
      t.string :process_order
      t.string :incomplete_bin_tag

      t.timestamps
    end
    add_index :movements, :movement_type
    add_index :movements, :warehouse_responsable
    add_index :movements, :destination
    add_index :movements, :process_order
  end
end
