class AddSlugToLegumes < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :slug, :string
    add_index :legumes, :slug, unique: true
  end
end
