class AddVenteToCommentaire < ActiveRecord::Migration[5.2]
  def change
    add_reference :commentaires, :vente, foreign_key: true
  end
end
