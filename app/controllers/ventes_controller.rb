class VentesController < ApplicationController
  def index
    @ventes = Vente.all
    @pointsdevente = VentePoint.all
  end

  def show
    @vente = Vente.find(params[:id])
    @lignesdevente = VenteLigne.all
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
  end

private

  def vente_params
    params.require(:vente).permit(:date, :vente_point_id)
  end
end
