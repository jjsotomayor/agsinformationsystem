class AddIndexToSamplesAverageOnCaliber < ActiveRecord::Migration[5.0]
  def change
    add_index :samples_averages, :caliber
  end
end
