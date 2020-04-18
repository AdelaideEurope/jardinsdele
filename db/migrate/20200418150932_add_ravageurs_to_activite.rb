class AddRavageursToActivite < ActiveRecord::Migration[5.2]
  def change
    add_column :activites, :maladie_ravageur, :boolean
  end
end
