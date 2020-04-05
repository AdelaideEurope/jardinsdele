class AddVilleToVentePoint < ActiveRecord::Migration[5.2]
  def change
    add_column :vente_points, :ville, :string
  end
end
