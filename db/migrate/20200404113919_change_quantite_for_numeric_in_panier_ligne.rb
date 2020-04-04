class ChangeQuantiteForNumericInPanierLigne < ActiveRecord::Migration[5.2]
  def change
    remove_column :panier_lignes, :quantite
    add_column :panier_lignes, :quantite, :decimal
  end
end
