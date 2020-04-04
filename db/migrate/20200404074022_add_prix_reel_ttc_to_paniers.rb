class AddPrixReelTtcToPaniers < ActiveRecord::Migration[5.2]
  def change
    add_column :paniers, :prix_reel_ttc, :decimal
  end
end
