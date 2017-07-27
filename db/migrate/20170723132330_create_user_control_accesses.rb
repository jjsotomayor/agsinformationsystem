class CreateUserControlAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_control_accesses do |t|

      t.references :user_control, foreign_key: true, null: false
      # Product type es equivalente a botones del menu
      t.references :product_type, foreign_key: true, null: false

      t.timestamps
    end
    add_index :user_control_accesses, [:user_control_id, :product_type_id], unique: true,
     name: 'index_user_accesses_on_user_control_id_and_product_type_id'

  end
end
