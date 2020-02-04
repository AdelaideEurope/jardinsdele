class CommentairesController < ApplicationController
  def index
    @commentaires = Commentaire.all
  end
end
