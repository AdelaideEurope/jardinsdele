class PaniersController < ApplicationController
  def show
    @panier = Panier.find(params[:id])
    @lignesdepanier = PanierLigne.all.where(panier_id: @panier.id)
    @vente = @panier.vente
  end

  def index
    @paniers = Panier.all
    @vente = Vente.find(params[:vente_id])
  end
end
