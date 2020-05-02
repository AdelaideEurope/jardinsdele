class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def home
    if current_user.admin != true
      flash[:notice] = "Malheureusement, vous ne pouvez pas accéder à cette page 😬"
      redirect_to landing_path
    end
    @memos = Memo.all
    @memo = Memo.new
    @ventes = Vente.all
    @legumes = Legume.all
    week = Date.today.strftime("%W").to_i + 1
    @memos_nepasoublierfuturs = @memos.reject { |memo| memo.date.nil? }.select { |memo| memo.categorie == "Ne pas oublier" }.select { |memo| memo.done == false }.reject { |memo| memo.date < Date.today }
    @memos_nepasoublierpasses = @memos.reject { |memo| memo.date.nil? }.select { |memo| memo.categorie == "Ne pas oublier" }.select { |memo| memo.done == false }.reject { |memo| memo.date >= Date.today }
    arecolter_ajd
    arecolter_j1
    arecolter_j2
    @ventes_futures_semaine = @ventes.reject { |memo| memo.date.nil? }.select { |vente| vente.date.strftime("%W").to_i + 1 == week }.reject { |vente| vente.date < Date.today }

    week = Date.today.strftime("%W").to_i + 1
    @todo_pas_faits = @memos.reject { |memo| memo.date.nil? }.select { |memo| memo.date < Date.today }.select { |memo| memo.categorie == "À faire" }.select { |memo| memo.done == false }
    @todo_this_week = @memos.reject { |memo| memo.date.nil? }.select { |memo| memo.date.strftime("%W").to_i + 1 == week }.select { |memo| memo.categorie == "À faire" }.select { |memo| memo.done == false }.reject { |memo| memo.date < Date.today }
    date_home
    next_week = Date.today.strftime("%W").to_i + 2
    @todo_next_week = @memos.reject { |memo| memo.date.nil? }.select { |memo| memo.date.strftime("%W").to_i + 1 == next_week }.select { |memo| memo.categorie == "À faire" }.select { |memo| memo.done == false }.reject { |memo| memo.date < Date.today }.select { |memo| memo.done == false }
    date_home
    @catotal = @ventes.map { |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    @caprevi = @legumes.select { |legume| !legume.previ_legume.nil? }.map { |legume| legume.previ_legume }.sum
    encouragements
    @afairesansdate = @memos.select { |memo| memo.date.nil? }
  end

  def photos
    @activites = Activite.all
  end

  private

  def date_home
    correspondance_datedujour_mois = { 1 => "janvier", 2 => "février", 3 => "mars", 4 => "avril", 5 => "mai", 6 => "juin", 7 => "juillet", 8 => "août", 9 => "septembre", 10 => "octobre", 11 => "novembre", 12 => "décembre" }
    correspondance_datedujour_jour = { 1 => ["lundi", "lun"], 2 => ["mardi", "mar"], 3 => ["mercredi", "mer"], 4 => ["jeudi", "jeu"], 5 => ["vendredi", "ven"], 6 => ["samedi", "sam"], 7 => ["dimanche", "dim"] }
    @jour = Date.today.strftime("%u").to_i
    @datedujour_mois = correspondance_datedujour_mois[Date.today.month]
    @datedujour_jour = correspondance_datedujour_jour[@jour][0]
  end

  def arecolter_ajd
    @lignesdepaniertoday = PanierLigne.select { |ligne| ligne.panier.vente.date == Date.today }
    @lignesdeventetoday = VenteLigne.select { |ligne| ligne.vente.date == Date.today }
    @arecolter_ajd = Hash.new { |arecolter, legume| arecolter[legume] = { unite: "", quantite: "".to_f } }
    @lignesdepaniertoday.sort_by(&:legume).each do |ligne|
      @arecolter_ajd[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_ajd[ligne.legume.nom][:quantite] += ligne.quantite * ligne.panier.quantite
    end
    @lignesdeventetoday.sort_by(&:legume).each do |ligne|
      @arecolter_ajd[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_ajd[ligne.legume.nom][:quantite] += ligne.quantite
    end
  end

  def arecolter_j1
    @lignesdepaniertomorrow = PanierLigne.select { |ligne| ligne.panier.vente.date == Date.tomorrow }
    @lignesdeventetomorrow = VenteLigne.select { |ligne| ligne.vente.date == Date.tomorrow }
    @arecolter_j1 = Hash.new { |arecolter, legume| arecolter[legume] = { unite: "", quantite: "".to_f } }
    @lignesdepaniertomorrow.sort_by(&:legume).each do |ligne|
      @arecolter_j1[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_j1[ligne.legume.nom][:quantite] += ligne.quantite * ligne.panier.quantite
    end
    @lignesdeventetomorrow.sort_by(&:legume).each do |ligne|
      @arecolter_j1[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_j1[ligne.legume.nom][:quantite] += ligne.quantite
    end
  end

  def arecolter_j2
    @lignesdepanierj2 = PanierLigne.select { |ligne| ligne.panier.vente.date == Date.today + 2.days }
    @lignesdeventej2 = VenteLigne.select { |ligne| ligne.vente.date == Date.today + 2.days }
    @arecolter_j2 = Hash.new { |arecolter, legume| arecolter[legume] = { unite: "", quantite: "".to_f } }
    @lignesdepanierj2.sort_by(&:legume).each do |ligne|
      @arecolter_j2[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_j2[ligne.legume.nom][:quantite] += ligne.quantite * ligne.panier.quantite
    end
    @lignesdeventej2.sort_by(&:legume).each do |ligne|
      @arecolter_j2[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_j2[ligne.legume.nom][:quantite] += ligne.quantite
    end
  end

  def encouragements
    encouragements = ["tu vas encore tout déchirer aujourd'hui !", "ce petit rayon de soleil va te donner des ailes !", "tes légumes sont délicieux !", "tu es vraiment un petit chou !", "tout va bien !", "today is your day!", "à chaque jour suffit sa feuille !", "on lâche rien !", "wow quelle énergie !", "mais dis donc tu as appelé ta sœur ?!", "si tu fêtais ça ?!", "c'est pas fini !", "c'est cette année que tu fais péter les plafonds ?", "tu es merveilleuse !", "tu es rayonnante !", "hakuna matata !"]
    if Date.today.to_s == "2020-05-14"
      @encouragement = "joyeux anniversaiiire !"
    else
      @encouragement = encouragements.sample
    end

  end
end
