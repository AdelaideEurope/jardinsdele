class AddCpToVentePoint < ActiveRecord::Migration[5.2]
  def change
    add_column :vente_points, :code_postal, :integer
  end
end
