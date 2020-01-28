class VentePointsController < ApplicationController
  def index
    @pointsdevente = VentePoint.all
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
    params.require(:vente_point).permit(:nom, :categorie)
  end

end
