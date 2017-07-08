class CreateIpAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :ip_addresses do |t|
      t.inet :ip, null:false
      t.string :comment

      t.timestamps
    end
  end
  # add_index :ip_addresses, :ip, unique: true
end
