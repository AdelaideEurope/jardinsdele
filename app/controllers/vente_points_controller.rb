class VentePointsController < ApplicationController
  def index
    @pointsdevente = VentePoint.all
    @ventes = Vente.all
    @catotal = @ventes.map{ |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    venteparca
    @firsthalf = (@pointsdevente.length/2.to_f).ceil
    @secondhalf = @pointsdevente.length/2
    @month = Date.today.month
    @ventes_mois_pdv = @pointsdevente.map { |pointdevente|
      { name: pointdevente.nom, data: vente_totaux(pointdevente) } }.sort_by {|pointdevente| pointdevente[:data][0]}.reverse
    pdv_colors = {"CG SMU" => "#849B68", "Les biaux légumes - Vizille" => "#9A3E43", "La Bonne Pioche" => "#7398A0", "Divers restos" => "#F4E285", "LJE VLB" => "#586846", "L'Épicerie" => "#3A585E", "Divers magasins" => "#466B72", "Divers !" => "#3A2449", "AMAP SMU" => "#C86B70", "René Thomas" => "#BACFA1", "La Corne d'Or" => "#F6E79B", "Divers" => "#3A2449"}
    @colors = []
    @ventes_mois_pdv.each do |pdv, _|
      @colors << pdv_colors[pdv[:name]]
    end
  end

  def vente_totaux(pdv)
    @months = (1..@month).to_a.reverse
    @arr_mois = []
    @months.each do |mois|
      totauxvente = pdv.ventes.select { |vente| vente.date.month == mois }.map do |vente|
        vente.montant_arrondi.nil? || vente.montant_arrondi == 0 ? vente.total_ttc : vente.montant_arrondi
      end
      @arr_mois << [mois, totauxvente.sum]
    end
    @arr_mois
  end

  def show
    @pointdevente = VentePoint.find(params[:id])
    @pointsdevente = VentePoint.all
    @ventes = @pointdevente.ventes
    @ventes_ac_panier = @ventes.select { |vente| vente.paniers.any? }
    @paniers = Panier.all.where(vente_id: @ventes.ids)
    @sommearrondis = @ventes.map {|vente| vente.montant_arrondi || 0 }.sum
    @sommeregles = @ventes.map {|vente| vente.montant_regle || 0 }.sum
    sommeapercevoir = []
    @ventes.each do |vente|
      if vente.montant_arrondi.nil? || vente.montant_arrondi == 0
        sommeapercevoir << (vente.total_ttc - vente.montant_regle)
      else
        sommeapercevoir << vente.montant_arrondi - vente.montant_regle
      end
    end
    @sommeapercevoir = sommeapercevoir.sum
    @commentaires = Commentaire.where(vente_id: @ventes.ids)
    venteparca
  end

  def new
    @pointdevente = VentePoint.new
  end

  def create
    @pointdevente = VentePoint.new(pointdevente_params)
    if @pointdevente.save
      flash[:notice] = "Point de vente créé avec succès !"
      redirect_to vente_points_path
    else
      render :new
    end
  end

  def edit
    @pointdevente = VentePoint.find(params[:id])
  end

  def update
    @pointdevente = VentePoint.find(params[:id])
    if @pointdevente.update(pointdevente_params)
      flash[:notice] = "Activité modifiée avec succès !"
      redirect_to vente_points_path
    else
      render :edit
    end
  end

private

  def pointdevente_params
    params.require(:vente_point).permit(:nom, :categorie, :total_ht, :total_ttc, :adresse, :ville, :code_postal, :email)
  end

  def venteparca
    @pointsdeventeparca = Hash.new { |hash, key| hash[key] = "".to_i }
    @pointsdevente.each do |pointdevente|
      @pointsdeventeparca[pointdevente] = pointdevente.ventes.map { |vente| vente.montant_arrondi.nil? || vente.montant_arrondi.zero? ? vente.total_ttc : vente.montant_arrondi }.sum
    end
  end
end
