class CreateCarozoSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :carozo_samples do |t|
      t.string :responsable
      t.references :element, foreign_key: true
      t.decimal :carozo_weight
      t.decimal :sample_weight
      t.decimal :carozo_percentage

      t.integer :status, null: false, default:0
      t.boolean :status_modified, null: false, default:false

      t.boolean :active, null: false, default:true
      t.datetime :deleted_at

      t.timestamps

    end
  end
end
