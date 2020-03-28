class AddPrixTtcToPanier < ActiveRecord::Migration[5.2]
  def change
    add_column :paniers, :prix_ht, :decimal
    add_column :paniers, :prix_ttc, :decimal
  end
end
