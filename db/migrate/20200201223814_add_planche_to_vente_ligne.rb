class AddPlancheToVenteLigne < ActiveRecord::Migration[5.2]
  def change
    add_reference :vente_lignes, :planche, foreign_key: true
  end
end
