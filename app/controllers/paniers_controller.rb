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

  def new
    @vente = Vente.find(params[:vente_id])
    @panier = Panier.new
    @pointdevente = @vente.vente_point
  end

  def create
    @vente = Vente.find(params[:vente_id])
    @pointdevente = @vente.vente_point
    vente_id = params[:vente_id]
    prix_ttc = params[:panier][:prix_ttc]
    quantite = params[:panier][:quantite]
    @panier = Panier.new(prix_ttc: prix_ttc, quantite: quantite, vente_id: vente_id)
    if @panier.save
      flash[:notice] = "Panier créé avec succès !"
      redirect_to vente_panier_path(@vente, @panier)
    else
      render :new
    end
  end
end
