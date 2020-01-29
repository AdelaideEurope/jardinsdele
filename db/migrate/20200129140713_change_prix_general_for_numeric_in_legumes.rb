class ChangePrixGeneralForNumericInLegumes < ActiveRecord::Migration[5.2]
  def change
    remove_column :legumes, :prix_general
    add_column :legumes, :prix_general, :decimal
  end
end
