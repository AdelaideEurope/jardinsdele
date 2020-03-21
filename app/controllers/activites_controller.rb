class ActivitesController < ApplicationController

  def index
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to activites_recap_path
    end
    @activites = Activite.all
    @totaux_activites = Hash.new { |h, k| h[k] = "".to_i }
    @activites.each do |activite|
      duree = activite.heure_fin - activite.heure_debut
      @totaux_activites[activite.nom] += duree
    end
    @total = @totaux_activites.values.sum.to_i
    @total_heures = convert_to_readable_hours(@total)
  end

  def new
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to activites_recap_path
    end
    @activite = Activite.new
    @activite.commentaires.build
    planches = Planche.all
    @jardins = planches.group_by { |planche| planche.jardin }
  end

  def create
    @activite = Activite.new(activite_params)
    if @activite.save
      flash[:notice] = "Activité créée avec succès !"
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
    @nom_activites = @activites.map { |activite| activite.nom }.uniq
    @months = ["01 Jan 2020", "01 Feb 2020", "01 Mar 2020", "01 Apr 2020", "01 May 2020", "01 Jun 2020"]
    @donnees = []

    @nom_activites.each do |nom|
      data = { @months[0] => rand(1000..2000), @months[1] => rand(1000..2000), @months[2] => rand(1000..2000), @months[3] => rand(1000..2000), @months[4] => rand(1000..2000), @months[5] => rand(1000..2000) }
      @donnees << { name: nom, data: data }
    end

    @totaux_activites = Hash.new { |h, k| h[k] = "".to_i }
    @activites.each do |activite|
      duree = activite.heure_fin - activite.heure_debut
      @totaux_activites[activite.nom] += duree.to_i
    end

    @totaux_activites_semaine = Hash.new { |h, k| h[k] = "".to_i }
    @activites_semaine.each do |activite|
      duree = activite.heure_fin - activite.heure_debut
      @totaux_activites_semaine[activite.nom] += duree.to_i
    end
    @total = @totaux_activites_semaine.values.sum.to_i
  end

  def edit
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to activites_recap_path
    end
    @activite = Activite.find(params[:id])
    planches = Planche.all
    @jardins = planches.group_by { |planche| planche.jardin }
  end

  def update
    @activite = Activite.find(params[:id])
    if @activite.update(activite_params)
      flash[:notice] = "Activité modifiée avec succès !"
      redirect_to activites_recap_path
    else
      render :edit
    end
  end

private

  def activite_params
    params.require(:activite).permit(:nom, :legume_id, :planche_id, :date, :duree, :assistant_id, :tag_list, :heure_debut, :heure_fin, commentaires_attributes: [:id, :description, :activite_id], photos: [])
  end

  def convert_to_readable_hours(time)
    [time/3600, time/60%60].map { |t| t.to_s.rjust(2,'0') }.join('h')
  end

end
