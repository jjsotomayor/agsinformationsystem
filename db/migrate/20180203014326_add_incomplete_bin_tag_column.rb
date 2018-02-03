class AddIncompleteBinTagColumn < ActiveRecord::Migration[5.0]
  def change
    # Esto se usa para bodega cuando reingresa un bin incompleto
    add_column :elements, :incomplete_bin_tag, :string
  end
end
