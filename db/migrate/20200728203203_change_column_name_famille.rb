class ChangeColumnNameFamille < ActiveRecord::Migration[5.2]
  def change
    rename_column :legumes, :famille_legumes_id, :familles_legume_id
  end
end
