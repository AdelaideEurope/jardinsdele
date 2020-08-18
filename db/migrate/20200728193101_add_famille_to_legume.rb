class AddFamilleToLegume < ActiveRecord::Migration[5.2]
  def change
    add_reference :legumes, :famille, foreign_key: true
  end
end
