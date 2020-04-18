class AddPreviLegumeToLegume < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :previ_legume, :decimal
  end
end
