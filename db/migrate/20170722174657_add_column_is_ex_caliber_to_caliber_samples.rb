class AddColumnIsExCaliberToCaliberSamples < ActiveRecord::Migration[5.0]
  def change
    add_column :caliber_samples, :is_ex_caliber, :boolean, default: false, null: false
  end
end
