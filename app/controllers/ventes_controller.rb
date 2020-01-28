class VentesController < ApplicationController
  def index
    @ventes = Vente.all
  end

  def new
    @vente = Vente.new
  end

  def create
    @vente = Vente.new(vente_params)
    if @vente.save
      flash[:notice] = "Vente créée avec succès !"
      redirect_to ventes_recap_path
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
