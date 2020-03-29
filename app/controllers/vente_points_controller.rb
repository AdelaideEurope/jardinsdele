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
    @vente_recente = @pointdevente.ventes.last
    @paniers = Panier.all.where(vente_id: @ventes.ids)
    @ventes_moins_un = @ventes[0...-1]
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
    params.require(:vente_point).permit(:nom, :categorie, :total_ht, :total_ttc)
  end

end
