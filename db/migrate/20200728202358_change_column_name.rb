class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :legumes, :famille_id, :famille_legumes_id
  end
end
