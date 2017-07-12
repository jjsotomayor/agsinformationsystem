class AddSoftDelete < ActiveRecord::Migration[5.0]
  def change
    add_column :humidity_samples, :active, :boolean, default: true, null: false
    add_column :humidity_samples, :deleted_at, :datetime

    add_column :sorbate_samples, :active, :boolean, default: true, null: false
    add_column :sorbate_samples, :deleted_at, :datetime

  end
end
