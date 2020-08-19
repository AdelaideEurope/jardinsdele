class AddTotalLegumeToLegume < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :total_ttc_legume, :decimal
  end
end
