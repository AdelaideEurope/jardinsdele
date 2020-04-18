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
    @activites = Activite.all
    @legumes = Legume.all
    @legumesparca = Hash.new { |hash, key| hash[key] = 0 }
    @legumes.each do |legume|
      @legumesparca[legume] = legume.vente_lignes.map { |ligne| ligne.prixunitairettc * ligne.quantite }.sum + legume.panier_lignes.map { |ligne| ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite }.sum
    end
    @meilleurslegumes = @legumesparca.sort_by{ |k, v| v}.reverse.first(3).map {|legume| legume[0] }
    @activites = Activite.all
    @planches = Planche.all
    @jardins = @planches.group_by { |planche| planche.jardin }
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @ventes = Vente.all

    @tempslegume = Hash.new { |h,k| h[k] = "".to_i }
    @meilleurslegumes.each do |legume|
      legume.activites.each do |activite|
        duree = activite.heure_fin - activite.heure_debut
        @tempslegume[legume.nom] += duree
      end
    end
    @lignesgroupees = Hash.new { |hash, key| hash[key] = {total: "".to_f, legumes: [] } }
    @planches.each do |planche|
      @lignesdepanier.select { |lignedepanier| lignedepanier.planche == planche }.each do |lignedepanier|
        @lignesgroupees[planche][:total] += lignedepanier.prixunitairettc * lignedepanier.quantite * lignedepanier.panier.quantite
        unless @lignesgroupees[planche][:legumes].include?(lignedepanier.legume.nom)
          @lignesgroupees[planche][:legumes] << lignedepanier.legume.nom
        end
      end
      @lignesdevente.select { |lignedevente| lignedevente.planche == planche }.each do |lignedevente|
        @lignesgroupees[planche][:total] += (lignedevente.prixunitairettc) * (lignedevente.quantite)
        unless @lignesgroupees[planche][:legumes].include?(lignedevente.legume.nom)
          @lignesgroupees[planche][:legumes] << lignedevente.legume.nom
        end
      end
    end
    @catotal = @ventes.map(&:total_ttc).sum
    lignessousserre
    planchesenrecolte

    planchesencours = []
    @planches.each do |planche|
      activitesplanche = {}
      planche.activites.sort_by(&:date).each do |activite|
        unless activite.legume.nil?
          activitesplanche[activite.legume.nom] = []
        end
      end
       planche.activites.sort_by(&:date).each do |activite|
        unless activite.nil? || activite.legume.nil?
          activitesplanche[activite.legume.nom] << activite.nom
        end
      end
      if activitesplanche.empty?
        planche.nom
      elsif activitesplanche.length == 1
        activitesplanche.each do |nomlegume, array|
          if array.include?("Plantation") && array.exclude?("Nettoyage planche")
            planchesencours << planche.nom
          elsif (["Plantation", "Nettoyage planche"] - array.uniq).empty? && array.reverse.index("Plantation") < array.reverse.index("Nettoyage planche")
            planchesencours << planche.nom
          else
            planche.nom
          end
        end
      else
        activitesplanche.each do |nomlegume, array|
          if array.include?("Plantation") && array.exclude?("Nettoyage planche")
            planchesencours << planche.nom
          elsif (["Plantation", "Nettoyage planche"] - array.uniq).empty? && array.reverse.index("Plantation") < array.reverse.index("Nettoyage planche")
            planchesencours << planche.nom
          end
        end
      end
    end
    @planchesencours = planchesencours.uniq.count - 1


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

    @quantitelegume = Hash.new { |hash, key| hash[key] = "".to_i }
    @lignesdeventeparlegume.each do |ligne|
      @quantitelegume[ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite] += ligne.quantite
    end
    @lignesdepanierparlegume.each do |ligne|
      @quantitelegume[ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite] += ligne.quantite * ligne.panier.quantite
    end
  end

  private

  def legume_params
    params.require(:legume).permit(:nom, :legume_css, :prix_general, :photo, :famille, :previ_legume)
  end

  def lignessousserre
    @lignessousserre = 0
    @planches.where("jardin = ? OR jardin = ? OR jardin = ?", "Jardin D", "Jardin E", "Jardin F").each do |planche|
      @lignesdepanier.select { |lignedepanier| lignedepanier.planche == planche }.each do |lignedepanier|
        @lignessousserre += lignedepanier.prixunitairettc * lignedepanier.quantite * lignedepanier.panier.quantite
      end
      @lignesdevente.select { |lignedevente| lignedevente.planche == planche }.each do |lignedevente|
        @lignessousserre += (lignedevente.prixunitairettc) * (lignedevente.quantite)
      end
    end
  end

  def planchesenrecolte
    planchesrecolte = []
    planchesrecolte << @planches.select {|planche| planche.vente_lignes.any?}
    planchesrecolte << @planches.select {|planche| planche.panier_lignes.any? }
    @planchesenrecolte = planchesrecolte.flatten.uniq.count
  end
end

