class CreateFamilles < ActiveRecord::Migration[5.2]
  def change
    create_table :familles do |t|
      t.string :nom
      t.string :couleur

      t.timestamps
    end
  end
end
