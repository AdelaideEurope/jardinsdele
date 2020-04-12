class AddNumFactureToVente < ActiveRecord::Migration[5.2]
  def change
    add_column :ventes, :date_facture, :datetime
    add_column :ventes, :num_facture, :integer
  end
end
