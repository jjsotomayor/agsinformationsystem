class CreateCalibers < ActiveRecord::Migration[5.0]
  def change
    create_table :calibers do |t|
      t.string :name, null: false, unique: true
      t.integer :minimum, null: false, unique: true
      t.integer :maximum, null: false, unique: true

      t.index :name, unique: true
      
      t.timestamps
    end
  end
end
