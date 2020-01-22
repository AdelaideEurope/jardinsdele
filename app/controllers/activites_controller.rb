class ActivitesController < ApplicationController
  def index
    @activites = Activite.all
  end

  def new
    @activite = Activite.new
    @activite.commentaires.build
  end

  def create
    @activite = Activite.new(activite_params)
    if @activite.save
      redirect_to activites_recap_path
    else
      render :new
    end
  end

  def show
    @activite = Activite.find(params[:id])
    @commentaire = Commentaire.find_by activite_id: @activite.id || ""
  end

  def recap
    @activites = Activite.all
    @activites_semaine = Activite.where('date >= ? AND date <= ?', DateTime.now.beginning_of_week, DateTime.now.end_of_week)
    @commentaires = Commentaire.all
  end

  def edit
    @activite = Activite.find(params[:id])
  end

  def update
    @activite = Activite.find(params[:id])
    if @activite.update(activite_params)
      redirect_to activites_recap_path
    else
      render :edit
    end
  end

private

  def activite_params
    params.require(:activite).permit(:nom, :legume_id, :planche_id, :date, :duree, :assistant_id, :tag_list, :heure_debut, :heure_fin, commentaires_attributes: [:id, :description, :activite_id])
  end

end
