class AddUniteToVenteLigne < ActiveRecord::Migration[5.2]
  def change
    add_column :vente_lignes, :unite, :string
  end
end
