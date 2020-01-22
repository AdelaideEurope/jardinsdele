class CreateLegumes < ActiveRecord::Migration[5.2]
  def change
    create_table :legumes do |t|
      t.string :nom
      t.string :prix_general

      t.timestamps
    end
  end
end
