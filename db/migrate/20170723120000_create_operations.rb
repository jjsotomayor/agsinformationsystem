class CreateOperations < ActiveRecord::Migration[5.0]
  def change
    create_table :operations do |t|
      t.string :name

      t.timestamps
    end
    add_index :operations, :name,                unique: true

  end
end
