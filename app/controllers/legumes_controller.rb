class LegumesController < ApplicationController
  def index
    @legumes = Legume.all
    @ventes = Vente.all
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @firsthalf = (@legumes.length / 2.to_f).ceil
    @secondhalf = @legumes.length / 2
    @tous_legumes_parlegume = @legumes.map { |legume|
      { nom: legume.nom, legume_css: legume.legume_css, duree: legume.activites.reject { |activite| activite.nom == "Récolte et préparation vente" }.map { |activite| activite.heure_fin - activite.heure_debut }.sum, calegume: calegume(legume), pourcentage_ca: pourcentage_ca(legume), commentaires: legume.commentaires.reject { |commentaire| commentaire.description.empty? }, photos: photo?(legume) } }.sort_by { |hashlegume| hashlegume[:legume_css] }
    @tous_legumes_parca = @legumes.map { |legume|
      { nom: legume.nom, legume_css: legume.legume_css, duree: legume.activites.map { |activite| activite.heure_fin - activite.heure_debut }.sum, calegume: calegume(legume), pourcentage_ca: pourcentage_ca(legume), commentaires: legume.commentaires.reject { |commentaire| commentaire.description.empty? && commentaire.description == "" }, photos: photo?(legume) } }.sort_by { |hashlegume| hashlegume[:calegume] }.reverse
    @legumes_semaines_graph = @legumes.map { |legume| { name: legume.nom, data: legumes_semaines_graph(legume) } }.sort_by { |hashlegume| hashlegume[:data].last.last }.reverse
  end

  def legumes_semaines_graph(legume)
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @arr_weeks = []
    @weeks.reverse.each do |week|
      totauxlegume = 0
      @lignesdevente.select { |ligne| ligne.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite
      end
      @lignesdepanier.select { |lignedepanier| lignedepanier.panier.valide == true }.select { |ligne| ligne.panier.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite
      end
      @arr_weeks << [week, totauxlegume.round(2)]
    end
    @arr_weeks
  end

  def photo?(legume)
    photos = []
    legume.activites.each do |activite|
      photos << activite.photos.any?
    end
    photos.include?(true)
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
      @legumesparca[legume] = legume.vente_lignes.map { |ligne| ligne.prixunitairettc * ligne.quantite }.sum + legume.panier_lignes.select {|lignedepanier| lignedepanier.panier.valide == true }.map { |ligne| ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite }.sum
    end
    @meilleurslegumes = @legumesparca.sort_by { |_k, v| v }.reverse.first(3).map { |legume| legume[0] }
    @activites = Activite.all
    @planches = Planche.all
    @jardins = @planches.group_by(&:jardin)
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @ventes = Vente.all

    @tempslegume = Hash.new { |h, k| h[k] = "".to_i }
    @meilleurslegumes.each do |legume|
      legume.activites.each do |activite|
        duree = activite.heure_fin - activite.heure_debut
        @tempslegume[legume.nom] += duree
      end
    end
    @catotal = @ventes.map(&:total_ttc).sum
    lignessousserre
    planchesenrecolte
    lignesgroupees
    planchesencours
  end

  def show
    @legume = Legume.friendly.find(params[:id])
    @activites = @legume.activites
    @lignesdeventeparlegume = @legume.vente_lignes
    @lignesdepanierparlegume = @legume.panier_lignes
    @ventes = Vente.all
    @catotal = @ventes.map(&:total_ttc).sum
    @totauxlegume = Hash.new { |h, k| h[k] = "".to_i }
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
    @calegume = @lignesdeventeparlegume.map { |ligne| ligne.prixunitairettc * ligne.quantite }.sum + @lignesdepanierparlegume.select {|lignedepanier| lignedepanier.panier.valide == true }.map { |ligne| ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite }.sum
    @pourcentagedulegume = (@calegume * 100).fdiv(@catotal).round(2)

    @quantitelegume = Hash.new { |hash, key| hash[key] = "".to_i }
    @lignesdeventeparlegume.each do |ligne|
      @quantitelegume[ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite] += ligne.quantite
    end
    @lignesdepanierparlegume.each do |ligne|
      @quantitelegume[ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite] += ligne.quantite * ligne.panier.quantite
    end
    @ventes_legume_sem = legume_totaux(@legume)
    plancheslegumes
    plancheslegumes_graph
    @planches_legume_graph = @planches_legumes_graph.map { |value| { name: value[:nom], data: value[:ventes] } }
  end

  private

  def plancheslegumes
    @plancheslegumes = []
    @lignesdepanierparlegume.each do |ligne|
      @plancheslegumes << ligne.planche
    end
    @lignesdeventeparlegume.each do |ligne|
      @plancheslegumes << ligne.planche
    end
    @plancheslegumes = @plancheslegumes.uniq - [nil]
    @planches_legumes = @plancheslegumes.sort.map do |planche|
      { nom: planche.nom, ventes: ventes_semaines(planche) }
    end
  end

  def plancheslegumes_graph
    @plancheslegumes = []
    @lignesdepanierparlegume.each do |ligne|
      @plancheslegumes << ligne.planche
    end
    @lignesdeventeparlegume.each do |ligne|
      @plancheslegumes << ligne.planche
    end
    @plancheslegumes = @plancheslegumes.uniq
    @planches_legumes_graph = @plancheslegumes.map do |planche|
      nomplanche = planche.nil? ? "Autres planches" : planche.nom
      { nom: nomplanche, ventes: ventes_semaines_graph(planche) }
    end
  end

  def ventes_semaines(planche)
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @arr_weeks = []
    @weeks.reverse.each do |week|
      totauxlegume = 0
      @lignesdeventeparlegume.select { |ligne| ligne.vente.date.strftime("%W").to_i + 1 == week && ligne.planche == planche }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite
      end
      @lignesdepanierparlegume.select {|lignedepanier| lignedepanier.panier.valide == true }.select { |ligne| ligne.panier.vente.date.strftime("%W").to_i + 1 == week && ligne.planche == planche }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite
      end
      @arr_weeks << { "S#{week}".to_sym => totauxlegume }
    end
    @arr_weeks
  end

  def ventes_semaines_graph(planche)
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @arr_weeks = []
    @weeks.reverse.each do |week|
      totauxlegume = 0
      @lignesdeventeparlegume.select { |ligne| ligne.vente.date.strftime("%W").to_i + 1 == week && ligne.planche == planche }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite
      end
      @lignesdepanierparlegume.select { |lignedepanier| lignedepanier.panier.valide == true }.select { |ligne| ligne.panier.vente.date.strftime("%W").to_i + 1 == week && ligne.planche == planche }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite
      end
      @arr_weeks << [week, totauxlegume]
    end
    @arr_weeks
  end

  def legume_totaux(legume)
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @arr_weeks = []
    @weeks.each do |week|
      totauxlegume = 0
      legume.vente_lignes.select { |ligne| ligne.vente.date.strftime("%W").to_i + 1 == week }.each do |ligne|
          totauxlegume += ligne.prixunitairettc * ligne.quantite
        end
      legume.panier_lignes.select {|lignedepanier| lignedepanier.panier.valide == true }.select {|ligne| ligne.panier.vente.date.strftime("%W").to_i + 1 == week }.each do |ligne|
          totauxlegume += ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite
        end
      @arr_weeks << [week, totauxlegume]
    end
    @arr_weeks
  end

  def totaux_planches(week)
    planches = []
    @lignesdepanierparlegume.select { |lignedepanier| !lignedepanier.planche.nil? && lignedepanier.panier.vente.date.strftime("%W").to_i == week }.each do |lignedepanier|
        if planches.any? { |planche| planche[:nom] = lignedepanier.planche.nom }
          hashplanche = planches.find { |h| h[:nom] == lignedepanier.planche.nom }
          hashplanche[:total] += lignedepanier.quantite * lignedepanier.prixunitairettc * lignedepanier.panier.quantite
        else
          planches << { nom: lignedepanier.planche.nom, total: lignedepanier.quantite * lignedepanier.prixunitairettc * lignedepanier.panier.quantite }
        end
    end
    @lignesdeventeparlegume.select { |lignedevente| !lignedevente.planche.nil? && lignedevente.vente.date.strftime("%W").to_i == week }.each do |lignedevente|
      if planches.any? { |planche| planche[:nom] = lignedevente.planche.nom }
        hashplanche = planches.find { |h| h[:nom] == lignedevente.planche.nom }
        hashplanche[:total] += lignedevente.quantite * lignedevente.prixunitairettc
      else
        planches << { nom: lignedevente.planche.nom, total: lignedevente.quantite * lignedevente.prixunitairettc }
      end
    end
    planches.uniq
  end

  def catotal_legumes
    @ventes.map(&:total_ttc).sum
  end

  def calegume(legume)
    @lignesdeventeparlegume = legume.vente_lignes
    @lignesdepanierparlegume = legume.panier_lignes
    @lignesdeventeparlegume.map { |ligne| ligne.prixunitairettc * ligne.quantite }.sum + @lignesdepanierparlegume.select {|lignedepanier| lignedepanier.panier.valide == true }.map { |ligne| ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite }.sum
  end

  def pourcentage_ca(legume)
    if !calegume(legume).nil?
      (calegume(legume)*100/catotal_legumes).round(2)
    else
      0
    end
  end

  def legume_params
    params.require(:legume).permit(:nom, :legume_css, :prix_general, :photo, :famille, :previ_legume, :nb_planche)
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

  def lignesgroupees
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
  end

  def planchesencours
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
end

