class CommentairesController < ApplicationController
  def index
    if params[:query]
      @commentaires_all = Commentaire.all
      @commentaires = @commentaires_all.global_search(params[:query])
    else
      @commentaires = Commentaire.all
    end
  end

  def create
    @vente = Vente.find(params[:vente_id])
    @commentaire = Commentaire.new(commentaire_params)
    @commentaire.vente = @vente
    if @commentaire.save
      redirect_to vente_path(@vente)
    else
      render 'ventes/show'
    end
  end

  def destroy
    @commentaire = Commentaire.find(params[:id])
    @vente = @commentaire.vente
    @commentaire.destroy
    redirect_to vente_path(@vente)
  end

  private

  def commentaire_params
    params.require(:commentaire).permit(:description)
  end
end
