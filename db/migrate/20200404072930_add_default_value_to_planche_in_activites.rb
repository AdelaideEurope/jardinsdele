class AddDefaultValueToPlancheInActivites < ActiveRecord::Migration[5.2]
  def change
    change_column :activites, :planche_id, :integer, default: 76
  end
end
