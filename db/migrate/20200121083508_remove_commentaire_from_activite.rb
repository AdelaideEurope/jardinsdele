class RemoveCommentaireFromActivite < ActiveRecord::Migration[5.2]
  def change
    remove_reference :activites, :commentaire, foreign_key: true
  end
end
