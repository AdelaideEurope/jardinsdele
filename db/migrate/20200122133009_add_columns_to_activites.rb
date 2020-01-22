class AddColumnsToActivites < ActiveRecord::Migration[5.2]
  def change
    add_column :activites, :heure_debut, :time
    add_column :activites, :heure_fin, :time
  end
end
