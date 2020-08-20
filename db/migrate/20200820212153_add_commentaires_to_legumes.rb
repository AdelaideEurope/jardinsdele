class AddCommentairesToLegumes < ActiveRecord::Migration[5.2]
  def change
    add_column :legumes, :commentaires_legume, :text
  end
end
