class SetDefaultinVente < ActiveRecord::Migration[5.2]
  def change
    change_column :ventes, :total_ht, :decimal, :default => 0
    change_column :ventes, :total_ttc, :decimal, :default => 0
  end
end
