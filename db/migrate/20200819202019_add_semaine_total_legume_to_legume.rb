class AddSemaineTotalLegumeToLegume < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :total_legume_semaine, :text
  end
end
