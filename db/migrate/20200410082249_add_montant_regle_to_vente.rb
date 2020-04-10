class AddMontantRegleToVente < ActiveRecord::Migration[5.2]
  def change
    add_column :ventes, :montant_regle, :decimal, :default => 0
    add_column :ventes, :montant_arrondi, :decimal
  end
end
