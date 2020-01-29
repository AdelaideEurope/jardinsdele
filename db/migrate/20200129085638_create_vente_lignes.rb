class CreateVenteLignes < ActiveRecord::Migration[5.2]
  def change
    create_table :vente_lignes do |t|
      t.references :vente, foreign_key: true
      t.references :legume, foreign_key: true
      t.integer :quantite
      t.numeric :prixunitaireht
      t.numeric :prixunitairettc
      t.numeric :totalht
      t.numeric :totalttc

      t.timestamps
    end
  end
end
