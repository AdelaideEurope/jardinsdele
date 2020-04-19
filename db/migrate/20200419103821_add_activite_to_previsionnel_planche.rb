class AddActiviteToPrevisionnelPlanche < ActiveRecord::Migration[5.2]
  def change
    add_reference :previsionnel_planches, :activite, foreign_key: true
  end
end
