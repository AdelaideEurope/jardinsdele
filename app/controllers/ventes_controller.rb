class VentesController < ApplicationController
  def index
    @ventes = Vente.all
    @pointsdevente = VentePoint.all
    @ventes_semaine = @ventes.group_by { |m| m.date.strftime("%W").to_i + 1 }
    @ventes_mois = @ventes.group_by { |m| m.date.month }
    @week = Date.today.strftime("%W").to_i + 1
    @ventes_futures = @ventes.select { |vente| vente.date > Date.today }.sort_by(&:date).reverse
    @month = Date.today.month
    ventespourgraph
    @ventes_mois_cate_pdv = @pointsdevente.map { |pointdevente| pointdevente.categorie }.uniq.map do |categorie|
      { name: categorie, data: ventecategorie(categorie) }
    end
    cate_colors = {"Point de retrait" => "#A1BD7F", "Magasin" => "#55828B", "AMAP" => "#BC4B51", "Restaurant" => "#F4E285", "Divers" => "#3A2449" }
    @colors_categories = []
    @ventes_mois_cate_pdv.each do |cate, _|
      @colors_categories << cate_colors[cate[:name]]
    end
  end

  def ventecategorie(categorie)
    @months = (1..@month).to_a.reverse
    @arr_mois = []
    @months.each do |mois|
      pointsdevente_cate = @pointsdevente.where("categorie = ?", categorie)
      totauxvente = pointsdevente_cate.map(&:ventes).flatten.select { |vente| vente.date.month == mois }.map do |vente|
        vente.montant_arrondi.nil? || vente.montant_arrondi == 0 ? vente.total_ttc : vente.montant_arrondi
      end
      @arr_mois << [mois, totauxvente.sum]
    end
    @arr_mois
  end

  def show
    @vente = Vente.find(params[:id])
    @commentaire = Commentaire.new
    @lignedevente = VenteLigne.new
    @lignesdevente = @vente.vente_lignes
    @paniers = Panier.all.where(vente_id: @vente.id).select { |panier| panier.valide == true }
    @planches = Planche.all
    @jardins = @planches.group_by { |planche| planche.jardin }
    @factures_ac_num = Vente.all.reject { |vente| vente.num_facture.nil? }
    if @factures_ac_num.empty?
      @num_factures = 1
    else
      @num_factures = @factures_ac_num.map { |vente| vente.num_facture}.last + 1
    end
  end

  def new
    @vente = Vente.new
  end

  def create
    @vente = Vente.new(vente_params)
    if @vente.save
      flash[:notice] = "Vente créée avec succès !"
      redirect_to vente_path(@vente)
    else
      render :new
    end
  end

  def recap
    @ventes = Vente.all
    @pointsdevente = VentePoint.all
    @lignesdevente = VenteLigne.all
    @legumes = Legume.all
    @week = Date.today.strftime("%W").to_i + 1
    @ventes_semaine = @ventes.select { |m| m.date.strftime("%W").to_i + 1 == @week }
    @monthtoday = Date.today.month
    @ventes_mois = @ventes.select { |m| m.date.month == @monthtoday }
    @catotal = @ventes.map{ |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    @casemaine = @ventes_semaine.map{ |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    @camois = @ventes_mois.map{ |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    @ventes_panier = @ventes.select { |vente| vente.paniers.any? && vente.date >= Date.today }
    venteparca
    venteparcapourgraph
    ventesparpointdeventepourgraph

    @lignesdepaniertoday = PanierLigne.select { |ligne| ligne.panier.vente.date == Date.today }
    @lignesdeventetoday = VenteLigne.select { |ligne| ligne.vente.date == Date.today }
    @arecolter_ajd = Hash.new { |arecolter, legume| arecolter[legume] = { unite: "", quantite: "".to_f } }
    @lignesdepaniertoday.sort_by(&:legume).each do |ligne|
      @arecolter_ajd[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_ajd[ligne.legume.nom][:quantite] += (ligne.quantite * ligne.panier.quantite)
    end
    @lignesdeventetoday.sort_by(&:legume).each do |ligne|
      @arecolter_ajd[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter_ajd[ligne.legume.nom][:quantite] += (ligne.quantite)
    end
    @caprevi = @legumes.select {|legume| !legume.previ_legume.nil? }.map { |legume| legume.previ_legume }.sum

    pdv_colors = {"CG SMU" => "#849B68", "Les biaux légumes - Vizille" => "#9A3E43", "La Bonne Pioche" => "#7398A0", "Divers restos" => "#F4E285", "LJE VLB" => "#586846", "L'Épicerie" => "#3A585E", "Divers magasins" => "#466B72", "Divers !" => "#3A2449", "AMAP SMU" => "#C86B70", "René Thomas" => "#BACFA1", "La Corne d'Or" => "#F6E79B", "Divers" => "#3A2449"}
    @colors = []
    @pointsdeventeca.each do |pdv, _|
      @colors << pdv_colors[pdv]
    end

    cate_colors = {"Point de retrait" => "#A1BD7F", "Magasin" => "#55828B", "AMAP" => "#BC4B51", "Restaurant" => "#F4E285", "Divers" => "#3A2449"}
    @colors_categories = []
    @pointsdeventeparcapourgraph.each do |cate, _|
      @colors_categories << cate_colors[cate]
    end

  end

  def facture
    @vente = Vente.find(params[:id])
    @pointdevente = @vente.vente_point
    @commentaire = Commentaire.new
    @lignedevente = VenteLigne.new
    @lignesdevente = @vente.vente_lignes
    @paniers = Panier.all.where(vente_id: @vente.id).select { |panier| panier.valide == true }
  end

  def impayes
    @ventes = Vente.all
    @impayes = @ventes.select {|vente| vente.resteapercevoir > 0}
    @totalimpayes = @ventes.select {|vente| vente.resteapercevoir}.map {|vente| vente.resteapercevoir}.sum
  end

  def update
    @vente = Vente.find(params[:id])
    montant_regle = params[:vente][:montant_regle]
    montant_arrondi = params[:vente][:montant_arrondi]
    num_facture = params[:vente][:num_facture]
    date_facture = params[:vente][:date_facture]
    if montant_arrondi.nil? && montant_regle.nil?
      if @vente.update(num_facture: num_facture, date_facture: date_facture)
        redirect_to vente_facture_path(@vente)
      end
    elsif montant_regle.nil? || montant_regle == ""
      if @vente.update(montant_arrondi: montant_arrondi)
        flash[:notice] = "Montant arrondi renseigné avec succès !"
        redirect_to vente_path(@vente)
      end
    elsif montant_arrondi.nil? || montant_regle == ""
      if @vente.update(montant_regle: montant_regle)
        flash[:notice] = "Montant réglé renseigné avec succès !"
        redirect_to vente_path(@vente)
      end
    end
  end

private

  def vente_params
    params.require(:vente).permit(:date, :vente_point_id)
  end

  def ttc_to_ht(prix)
    prix - (prix * 5.5.fdiv(100))
  end

  def ht_to_ttc(prix)
    prix + (prix * 5.5.fdiv(100))
  end

  def venteparca
    @pointsdeventeparca = Hash.new { |hash, key| hash[key] = "".to_i }
    @pointsdevente.each do |pointdevente|
      @pointsdeventeparca[pointdevente] = pointdevente.ventes.map { |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    end
  end

  def venteparcapourgraph
    @pointsdeventeparcapourgraph = Hash.new { |hash, key| hash[key] = "".to_i }
    @pointsdevente.each do |pointdevente|
      @pointsdeventeparcapourgraph[pointdevente.categorie] += pointdevente.ventes.map { |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    end
  end

  def ventespourgraph
    @ventespourgraph = Hash.new { |hash, key| hash[key] = "".to_i }
    @ventes.each do |vente|
      @ventespourgraph[vente.date.month] += vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi
    end
  end

  def ventesparpointdeventepourgraph
    @pointsdeventeca = Hash.new { |hash, key| hash[key] = "".to_i }
    @pointsdevente.each do |pointdevente|
      @pointsdeventeca[pointdevente.nom] = pointdevente.ventes.map { |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    end
  end

end
