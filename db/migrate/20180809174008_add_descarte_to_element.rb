class AddDescarteToElement < ActiveRecord::Migration[5.0]
  def change
    add_column :elements, :descarte, :boolean, default: false, null: false
  end
end
