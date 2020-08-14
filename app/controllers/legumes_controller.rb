class LegumesController < ApplicationController
  def index
    @legumes = Legume.all
    @ventes = Vente.all
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @firsthalf = (@legumes.size / 2.to_f).ceil
    @secondhalf = @legumes.size / 2

    @tous_legumes_parlegume = @legumes.includes(:commentaires, :vente_lignes, :panier_lignes).map { |legume|
      { nom: legume.nom, legume_css: legume.legume_css, planches: nb_planches(legume), calegume: calegume(legume), pourcentage_ca: pourcentage_ca(legume), commentaires: legume.commentaires.where.not(description: [nil, ""]), photos: photo?(legume) } }.sort_by { |hashlegume| hashlegume[:legume_css] }

    @tous_legumes_parca = @legumes.map { |legume|
      { nom: legume.nom, legume_css: legume.legume_css, calegume: calegume(legume), pourcentage_ca: pourcentage_ca(legume), planches: nb_planches(legume), commentaires: legume.commentaires.where.not(description: [nil, ""]), photos: photo?(legume) } }.sort_by { |hashlegume| -hashlegume[:calegume] }

    @legumes_semaines_graph = @legumes.map { |legume| { name: legume.nom, legume_css: legume.legume_css, data: legumes_semaines_graph(legume), famille: legume.famille.downcase.tr("é", "e") } }.sort_by { |hashlegume| -hashlegume[:name].downcase.tr("é", "e") }
    # familles_colors = { "alliacees" => "#FF6600", "apiacees" => "#99CC33", "asteracees" => "#CC0000", "brassicacees" => "#33CCFF", "chenopodacees" => "#FFCC00", "cucurbitacees" => "#660099", "divers" => "#990000", "fabacees" => "#006633", "solanacees" => "#009999" }

    @colors = @legumes.sort_by(&:legume_css).map { |legume| legume.familles_legume.couleur }
    # @colors = []
    # @legumes_semaines_graph.each do |legume|
    #   @colors << familles_colors[legume[:famille]]
    # end
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
      @legumesparca[legume] = legume.vente_lignes.map { |ligne| ligne.prixunitairettc * ligne.quantite }.sum + legume.panier_lignes.select { |lignedepanier| lignedepanier.panier.valide == true }.map { |ligne| ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite }.sum
    end
    @meilleurslegumes = @legumesparca.sort_by { |_k, v| v }.last(3).map { |legume| legume[0] }
    @activites = Activite.all
    @planches = Planche.all
    @jardins = @planches.group_by(&:jardin)
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @ventes = Vente.all

    @tempslegume = Hash.new { |h, k| h[k] = "".to_i }
    @meilleurslegumes.each do |legume|
      legume.activites.each do |activite|
        @tempslegume[legume.nom] += activite.duree.to_i
      end
    end
    @catotal = @ventes.sum('total_ttc')
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
    @lignesparlegume = @legume.vente_lignes + @legume.panier_lignes
    @lignes_legume = @lignesparlegume.map { |ligne| { date: date_ligne(ligne), pdv: pdv_ligne(ligne), vente: vente_ligne(ligne), quantite: quantite_ligne(ligne), unite: unite_ligne(ligne) } }
    @ventes = Vente.all
    @catotal = @ventes.sum('total_ttc')
    @dureedulegume = @legume.activites.reject { |activite| activite.nom == "Récolte et préparation vente" }.sum('duree')
    @calegume = @lignesdeventeparlegume.map { |ligne| ligne.prixunitairettc * ligne.quantite }.sum + @lignesdepanierparlegume.select { |lignedepanier| lignedepanier.panier.valide == true }.map { |ligne| ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite }.sum
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

  def unite_ligne(ligne)
    if ligne.unite == ""
      quantite_ligne(ligne) > 1 && ligne.legume.unite != "kg" ? ligne.legume.unite.pluralize : ligne.legume.unite
    else
      quantite_ligne(ligne) > 1 && ligne.unite != "kg" ? ligne.unite.pluralize : ligne.unite
    end
  end

  def date_ligne(ligne)
    if @lignesdepanierparlegume.include?(ligne)
      ligne.panier.vente.date.strftime("%d/%m")
    else
      ligne.vente.date.strftime("%d/%m")
    end
  end

  def vente_ligne(ligne)
    if @lignesdepanierparlegume.include?(ligne)
      ligne.panier.vente
    else
      ligne.vente
    end
  end

  def pdv_ligne(ligne)
    if @lignesdepanierparlegume.include?(ligne)
      ligne.panier.vente.vente_point
    else
      ligne.vente.vente_point
    end
  end

  def quantite_ligne(ligne)
    if @lignesdepanierparlegume.include?(ligne)
      ligne.quantite * ligne.panier.quantite
    else
      ligne.quantite
    end
  end

  def nb_planches(legume)
    planches = []
    legume.vente_lignes.map { |ligne| ligne.planche&.nom }.each do |ligne|
      unless planches.include?(ligne)
        planches << ligne
      end
    end

    legume.panier_lignes.map { |ligne| ligne.planche&.nom }.each do |ligne|
      unless planches.include?(ligne)
        planches << ligne
      end
    end
    planches.size
  end

  def legumes_semaines_graph(legume)
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @arr_weeks = []
    @weeks.reverse_each do |week|
      totauxlegume = 0
      @lignesdevente.select { |ligne| ligne.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite
      end
      @lignesdepanier.select { |lignedepanier| lignedepanier.panier.valide == true }.select { |ligne| ligne.panier.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite
      end
      @arr_weeks << [week, totauxlegume]
    end
    @arr_weeks
  end

  def photo?(legume)
    photos = []
    unless photos.include?(true)
      legume.activites.each do |activite|
        photos << activite.photos.any?
      end
    end
    photos
  end


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
    @weeks.reverse_each do |week|
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
    @weeks.reverse_each do |week|
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
    @ventes.sum('total_ttc')
  end

  def calegume(legume)
    @lignesdeventeparlegume = legume.vente_lignes
    @lignesdepanierparlegume = legume.panier_lignes
    calegume = 0
    @lignesdeventeparlegume.each { |ligne| calegume += ligne.prixunitairettc * ligne.quantite }
    @lignesdepanierparlegume.select {|lignedepanier| lignedepanier.panier.valide == true }.each { |ligne| calegume += (ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite) }
    calegume
  end

  def pourcentage_ca(legume)
    if !calegume(legume).nil? && !calegume(legume).zero?
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
    @planchesenrecolte = planchesrecolte.flatten.uniq.size
  end

  def lignesgroupees
    @lignesgroupees = Hash.new { |hash, key| hash[key] = { total: "".to_f, legumes: [] } }
    @planches.each do |planche|
      @lignesdepanier.select { |lignedepanier| lignedepanier.planche == planche }.each do |lignedepanier|
        @lignesgroupees[planche][:total] += lignedepanier.prixunitairettc * lignedepanier.quantite * lignedepanier.panier.quantite
        unless @lignesgroupees[planche][:legumes].include?(lignedepanier.legume)
          @lignesgroupees[planche][:legumes] << lignedepanier.legume
        end
      end
      @lignesdevente.select { |lignedevente| lignedevente.planche == planche }.each do |lignedevente|
        @lignesgroupees[planche][:total] += lignedevente.prixunitairettc * lignedevente.quantite
        unless @lignesgroupees[planche][:legumes].include?(lignedevente.legume)
          @lignesgroupees[planche][:legumes] << lignedevente.legume
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
    @planchesencours = planchesencours.uniq.size - 1
  end
end

