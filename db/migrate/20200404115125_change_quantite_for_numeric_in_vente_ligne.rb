class ChangeQuantiteForNumericInVenteLigne < ActiveRecord::Migration[5.2]
  def change
    remove_column :vente_lignes, :quantite
    add_column :vente_lignes, :quantite, :decimal
  end
end
