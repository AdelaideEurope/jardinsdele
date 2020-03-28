class CreatePaniers < ActiveRecord::Migration[5.2]
  def change
    create_table :paniers do |t|
      t.references :vente, foreign_key: true

      t.timestamps
    end
  end
end
