class AddPlancheToPanierLigne < ActiveRecord::Migration[5.2]
  def change
    add_reference :panier_lignes, :planche, foreign_key: true
  end
end
