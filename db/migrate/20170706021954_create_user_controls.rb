class CreateUserControls < ActiveRecord::Migration[5.0]
  def change
    create_table :user_controls do |t|
      t.string :name, null: false
      t.string :password

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps
    end

    add_index :user_controls, :name, unique: true
  end
end
