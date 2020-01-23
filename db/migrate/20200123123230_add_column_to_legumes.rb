class AddColumnToLegumes < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :legume_css, :string
  end
end
