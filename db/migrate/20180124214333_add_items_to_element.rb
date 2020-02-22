class AddItemsToElement < ActiveRecord::Migration[5.0]
  def change
    add_column :elements, :first_item, :string
    add_column :elements, :last_item, :string
  end
end
