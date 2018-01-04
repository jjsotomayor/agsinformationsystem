class AddColumnCountToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :damage_samples, :counter, :integer, null: false
    add_column :caliber_samples, :counter, :integer, null: false
  end
end
