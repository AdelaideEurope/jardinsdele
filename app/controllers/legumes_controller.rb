class LegumesController < ApplicationController
  def index
    @legumes = Legume.all
    @commentaires = Commentaire.all
    @activites = Activite.all
    @lignesdevente = VenteLigne.all
    @firsthalf = (@legumes.length/2.to_f).ceil
    @secondhalf = @legumes.length/2
    @sorted_legumes = @legumes.sort_by(&:legume_css)
  end

  def new
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to legumes_recap_path
    end
    @legume = Legume.new
  end

  def create
    @legume = Legume.new(legume_params)
    if @legume.save
      flash[:notice] = "Légume créé avec succès !"
      redirect_to legumes_path
    else
      render :new
    end
  end

  def edit
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to legumes_recap_path
    end
    @legume = Legume.friendly.find(params[:id])
  end

  def update
    @legume = Legume.friendly.find(params[:id])
    if @legume.update(legume_params)
      flash[:notice] = "Légume modifié avec succès !"
      redirect_to legumes_path
    else
      render :edit
    end
  end

  def recap
    @legumes = Legume.all
    @legumesparca = Hash.new { |hash, key| hash[key] = "".to_i }
    @legumes.each do |legume|
      @legumesparca[legume] = legume.vente_lignes.map { |ligne| ligne.totalttc.to_f }.sum + legume.panier_lignes.map { |ligne| ligne.totalttc.to_f }
    end
    @meilleurslegumes = @legumesparca.sort_by{ |k, v| v}.reverse.first(3).map {|legume| legume[0] }
    @activites = Activite.all
    @planches = Planche.all
    @jardins = @planches.group_by { |planche| planche.jardin }
    @lignesdevente = VenteLigne.all
  end

  def show
    @legume = Legume.friendly.find(params[:id])
    @activites = Activite.where(["legume_id = ?", @legume.id])
    @lignesdeventeparlegume = VenteLigne.where(["legume_id = ?", @legume.id])
    @lignesdepanierparlegume = PanierLigne.where(["legume_id = ?", @legume.id])
    @ventes = Vente.all
    @catotal = @ventes.map(&:total_ttc).sum
    @totauxlegume = Hash.new { |h,k| h[k] = "".to_i }
    @dureedulegume = []
    @planchesdulegume = []
    @legume.activites.each do |activite|
      @dureedulegume << activite.heure_fin - activite.heure_debut
    end
    @legume.activites.filter { |activite| activite.nom == "Plantation" }.each do |activite|
      @planchesdulegume << activite.planche.nom
    end
    @dureedulegume = @dureedulegume.sum
    @totauxlegume[@legume.nom] += @dureedulegume
    @calegume = @lignesdeventeparlegume.map { |ligne| ligne.prixunitairettc * ligne.quantite }.sum + @lignesdepanierparlegume.map { |ligne| ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite }.sum
    @pourcentagedulegume = (@calegume*100).fdiv(@catotal).round(2)
  end

  def legume_params
    params.require(:legume).permit(:nom, :legume_css, :prix_general, :photo, :famille)
  end

end

