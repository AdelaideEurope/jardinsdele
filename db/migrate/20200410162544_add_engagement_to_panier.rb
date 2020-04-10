class AddEngagementToPanier < ActiveRecord::Migration[5.2]
  def change
    add_column :paniers, :engagement, :boolean, :default => true
  end
end
