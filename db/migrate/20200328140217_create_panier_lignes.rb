class CreatePanierLignes < ActiveRecord::Migration[5.2]
  def change
    create_table :panier_lignes do |t|
      t.integer :quanite
      t.decimal :prixunitaireht
      t.decimal :prixunitairettc
      t.decimal :totalht
      t.decimal :totalttc
      t.references :panier, foreign_key: true
      t.references :legume, foreign_key: true

      t.timestamps
    end
  end
end
