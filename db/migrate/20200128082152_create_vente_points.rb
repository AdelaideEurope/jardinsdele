class CreateVentePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :vente_points do |t|
      t.string :nom
      t.string :categorie
      t.string :adresse
      t.string :email

      t.timestamps
    end
  end
end
