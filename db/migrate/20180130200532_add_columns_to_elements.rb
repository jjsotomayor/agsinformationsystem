class AddColumnsToElements < ActiveRecord::Migration[5.0]
  def change
    add_column :elements, :weight, :decimal
    add_column :elements, :warehouse_id, :integer
    add_column :elements, :banda, :string
    add_column :elements, :posicion, :string
    add_column :elements, :altura, :string

    add_column :elements, :stored_at, :datetime
    add_column :elements, :dispatched_at, :datetime
    add_column :elements, :warehouse_responsable, :string # Responsable que movio el producto

    add_column :elements, :destination, :string

    add_column :elements, :last_movement_at, :datetime # PErmite trackear el ultimo mov. y su responsable
    add_column :elements, :last_movement_type, :integer

    add_index :elements, :warehouse_id
    add_index :elements, :last_movement_type
    add_index :elements, :last_movement_at

  end
end
