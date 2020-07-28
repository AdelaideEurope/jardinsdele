class RenameFamilleTableToFamilleLegumes < ActiveRecord::Migration[5.2]
  def change
    rename_table :familles, :familles_legumes
  end
end
