class AddQuantiteToPaniers < ActiveRecord::Migration[5.2]
  def change
    add_column :paniers, :quantite, :integer
  end
end
