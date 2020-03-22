class AddFamilleToLegumes < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :famille, :string
  end
end
