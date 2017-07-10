class AddAuthorizedColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :authorized, :boolean, default: false, null: false
  end
end
