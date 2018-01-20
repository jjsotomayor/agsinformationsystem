class AddColumnPreviousColor < ActiveRecord::Migration[5.0]
  def change
    add_column :elements, :previous_color, :string
    remove_column :elements, :previous_usda
  end
end
