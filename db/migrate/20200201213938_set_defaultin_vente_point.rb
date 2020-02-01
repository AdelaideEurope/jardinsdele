class SetDefaultinVentePoint < ActiveRecord::Migration[5.2]
  def change
    change_column :vente_points, :total_ht, :decimal, :default => 0
    change_column :vente_points, :total_ttc, :decimal, :default => 0
  end
end
