class CommentairesController < ApplicationController
  def index
    if params[:query]
      @commentaires_all = Commentaire.all
      @commentaires = @commentaires_all.search(params[:query])
    else
      @commentaires = Commentaire.all
    end
  end
end
