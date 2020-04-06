class AddValideToPanier < ActiveRecord::Migration[5.2]
  def change
    add_column :paniers, :valide, :boolean, :default => false
  end
end
