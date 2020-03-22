class ActivitesController < ApplicationController

  def index
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to activites_recap_path
    end
    @activites = Activite.all
    @totaux_activites = Hash.new { |h, k| h[k] = "".to_i }
    @sorted_activites = @activites.order(date: :desc, heure_fin: :desc)
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
    @sorted_activites_semaine = @activites_semaine.order(date: :desc, heure_fin: :desc)
    @commentaires = Commentaire.all
    @nom_activites = @activites.map { |activite| activite.nom }.uniq
    @totaux_activites = totaux_activites

    @totaux_activites_semaine = Hash.new { |h, k| h[k] = "".to_i }
    @activites_semaine.each do |activite|
      duree = activite.heure_fin - activite.heure_debut
      @totaux_activites_semaine[activite.nom] += duree.to_i
    end
    @total = @totaux_activites_semaine.values.sum.to_i

    @totaljoursemaine = Hash.new { |h, k| h[k] = "".to_i }
    jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
    @totaux_activites_jour = {}
    counter = 0
    until counter == 7
      @activites_jour = Activite.where('date >= ? AND date <= ?', DateTime.now.beginning_of_week.beginning_of_day + counter.days, DateTime.now.beginning_of_week.end_of_day + counter.days)
      dureedujour = []
      @activites_jour.each do |activite|
        dureeactivite = activite.heure_fin - activite.heure_debut
        dureedujour << dureeactivite.to_i
      end
      dureedujour = dureedujour.sum.to_i
      @totaux_activites_jour[jours[counter]] = dureedujour
      counter += 1
    end

    # values for the graph
    @totaux_for_graph = []
    @activites_noms = @activites.map(&:nom).uniq
    @activites_noms.each do |nomactivite|
      @totaux_activites_mois = {}
      mois = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
      @totaux_chq_activite_mois = {}
      counter = 0
      nbdemoisecoules = DateTime.now.month - DateTime.now.beginning_of_year.month + 1
      until counter == nbdemoisecoules
        @activites_mois = Activite.where('date >= ? AND date <= ? AND nom = ?', DateTime.now.beginning_of_year.beginning_of_month + counter.months, DateTime.now.beginning_of_year.end_of_month + counter.months, nomactivite)
        dureedumois = []
        @activites_mois.each do |activite|
          dureeactivite = activite.heure_fin - activite.heure_debut
          dureedumois << dureeactivite.to_i
        end
        dureedumois = dureedumois.sum.to_i / 3600.to_f
        @totaux_chq_activite_mois[mois[counter]] = dureedumois.round(2)
        counter += 1
        @totaux_activites_mois[:name] = nomactivite
        @totaux_activites_mois[:data] = @totaux_chq_activite_mois
      end
      @totaux_for_graph << @totaux_activites_mois
    end
  end

  def edit
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to activites_recap_path
    end
    @activite = Activite.find(params[:id])
    planches = Planche.all
    @jardins = planches.group_by(&:jardin)
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

  def totaux_activites
    @totaux_activites = Hash.new { |h, k| h[k] = "".to_i }
    @activites.each do |activite|
      duree = activite.heure_fin - activite.heure_debut
      @totaux_activites[activite.nom] += duree.to_i
    end
  end
end
