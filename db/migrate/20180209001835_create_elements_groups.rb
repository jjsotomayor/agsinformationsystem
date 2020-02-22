class CreateElementsGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :elements_groups do |t|
      t.string :first_tag
      t.string :last_tag
      t.string :pre
      t.integer :first
      t.integer :last
      t.integer :int_pattern
      # t.integer :quantity
      # t.boolean :populated, default: false, null: false
      t.string :lot
      t.string :provider
      t.references :product_type, foreign_key: true
      t.references :drying_method, foreign_key: true
      t.integer :color, default: 0, null: false
      t.string :responsable

      t.timestamps
    end
    add_index :elements_groups, :color
  end
end
