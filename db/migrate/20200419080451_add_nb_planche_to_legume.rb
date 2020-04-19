class AddNbPlancheToLegume < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :nb_planche, :integer
  end
end
