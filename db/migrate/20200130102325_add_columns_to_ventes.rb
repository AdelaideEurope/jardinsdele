class AddColumnsToVentes < ActiveRecord::Migration[5.2]
  def change
    add_column :ventes, :total_ht, :decimal
    add_column :ventes, :total_ttc, :decimal
  end
end
