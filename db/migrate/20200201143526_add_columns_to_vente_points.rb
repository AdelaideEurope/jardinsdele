class AddColumnsToVentePoints < ActiveRecord::Migration[5.2]
  def change
    add_column :vente_points, :total_ht, :decimal
    add_column :vente_points, :total_ttc, :decimal
  end
end
