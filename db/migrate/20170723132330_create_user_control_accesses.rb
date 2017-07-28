class CreateUserControlAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_control_accesses do |t|
      t.references :user_control, foreign_key: true, null: false
      # Equivalente a botones del menu
      t.references :operation, foreign_key: true, null: false

      t.timestamps
    end
    add_index :user_control_accesses, [:user_control_id, :operation_id], unique: true,
     name: 'index_user_accesses_on_user_control_id_and_operation_id'

  end
end
