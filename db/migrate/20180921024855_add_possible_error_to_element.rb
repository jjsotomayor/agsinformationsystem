class AddPossibleErrorToElement < ActiveRecord::Migration[5.0]
  def change
    add_column :elements, :possible_error, :string, default: nil
  end
end
