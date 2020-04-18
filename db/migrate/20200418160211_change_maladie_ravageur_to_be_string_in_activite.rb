class ChangeMaladieRavageurToBeStringInActivite < ActiveRecord::Migration[5.2]
  def change
    change_column :activites, :maladie_ravageur, :string
  end
end
