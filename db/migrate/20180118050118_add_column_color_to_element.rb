class AddColumnColorToElement < ActiveRecord::Migration[5.0]
  def change
    add_column :elements, :color, :integer, default: 0, null: false
    add_index :elements, :color
  end
end
