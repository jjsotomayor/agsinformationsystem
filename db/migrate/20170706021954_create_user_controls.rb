class CreateUserControls < ActiveRecord::Migration[5.0]
  def change
    create_table :user_controls do |t|
      t.string :name
      t.string :password
      t.integer :sign_in_count

      t.timestamps
    end
  end
end
