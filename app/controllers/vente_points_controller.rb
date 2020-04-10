class VentePointsController < ApplicationController
  def index
    @pointsdevente = VentePoint.all
    @ventes = Vente.all
    @catotal = @ventes.map(&:total_ttc).sum
    @firsthalf = (@pointsdevente.length/2.to_f).ceil
    @secondhalf = @pointsdevente.length/2
  end

  def show
    @pointdevente = VentePoint.find(params[:id])
    @ventes = @pointdevente.ventes
    @ventes_ac_panier = @ventes.select { |vente| vente.paniers.any? }
    @paniers = Panier.all.where(vente_id: @ventes.ids)
    @sommearrondis = @ventes.map {|vente| vente.montant_arrondi }.sum
    @sommeregles = @ventes.map {|vente| vente.montant_regle }.sum
    sommeapercevoir = @ventes.map do |vente|
      if vente.montant_arrondi.nil? || vente.montant_arrondi == 0
        sommeapercevoir << vente.total_ttc - vente.montant_regle
      else
        vente.montant_arrondi - vente.montant_regle
      end
    end
    @sommeapercevoir = sommeapercevoir.sum
    @commentaires = Commentaire.where(vente_id: @ventes.ids)
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

end
