class ChangeNbPlancheToBeDecimalInLegume < ActiveRecord::Migration[5.2]
  def change
    change_column :legumes, :nb_planche, :decimal
  end
end
