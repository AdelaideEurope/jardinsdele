class AdduniteToLegumes < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :unite, :string
  end
end
