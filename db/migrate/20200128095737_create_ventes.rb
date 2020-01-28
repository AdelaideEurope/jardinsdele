class CreateVentes < ActiveRecord::Migration[5.2]
  def change
    create_table :ventes do |t|
      t.datetime :date
      t.references :vente_point, foreign_key: true

      t.timestamps
    end
  end
end
