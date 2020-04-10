class RemoveDefaultFromPanierEngagement < ActiveRecord::Migration[5.2]
  def change
    change_column_default :paniers, :engagement, nil
  end
end
