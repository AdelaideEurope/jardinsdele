class AddActiviteToCommentaires < ActiveRecord::Migration[5.2]
  def change
    add_reference :commentaires, :activite, foreign_key: true
  end
end
