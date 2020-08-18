class AddMessageToEncouragement < ActiveRecord::Migration[5.2]
  def change
    add_column :encouragements, :message, :string
    add_column :encouragements, :auteur, :string
  end
end
