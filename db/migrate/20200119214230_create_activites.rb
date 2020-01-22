class CreateActivites < ActiveRecord::Migration[5.2]
  def change
    create_table :activites do |t|
      t.string :nom
      t.string :duree
      t.references :planche, foreign_key: true
      t.references :legume, foreign_key: true
      t.references :assistant, foreign_key: true
      t.references :commentaire, foreign_key: true

      t.timestamps
    end
  end
end
