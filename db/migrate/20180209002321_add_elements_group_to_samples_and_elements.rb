class AddElementsGroupToSamplesAndElements < ActiveRecord::Migration[5.0]
  def change
    add_column :damage_samples, :elements_group_id, :integer
    add_column :caliber_samples, :elements_group_id, :integer
    add_column :humidity_samples, :elements_group_id, :integer
    #Samples tienen que tener o element_id o elements_group_id
    add_column :elements, :elements_group_id, :integer
    add_column :elements, :provider, :string

  end
end
