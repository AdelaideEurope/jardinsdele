class RenameQuaniteToQuantite < ActiveRecord::Migration[5.2]
  def change
    rename_column :panier_lignes, :quanite, :quantite
  end
end
