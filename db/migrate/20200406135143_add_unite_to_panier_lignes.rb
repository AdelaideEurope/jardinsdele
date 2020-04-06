class AddUniteToPanierLignes < ActiveRecord::Migration[5.2]
  def change
    add_column :panier_lignes, :unite, :string
  end
end
