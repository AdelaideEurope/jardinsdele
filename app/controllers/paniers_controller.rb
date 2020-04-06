class PaniersController < ApplicationController
  def show
    @vente = Vente.find(params[:vente_id])
    @panier = Panier.find(params[:id])
    @lignesdepanier = PanierLigne.all.where(panier_id: @panier.id)
  end

  def index
    @vente = Vente.find(params[:vente_id])
    @paniers = Panier.all.where(vente_id: @vente.id)
    @lignesdepanier = @vente.panier_lignes
    @arecolter = Hash.new { |arecolter, legume| arecolter[legume] = { unite: "", quantite: "".to_f } }
    @lignesdepanier.each do |ligne|
      @arecolter[ligne.legume.nom][:unite] = ligne.legume.unite.pluralize
      @arecolter[ligne.legume.nom][:quantite] += (ligne.quantite * ligne.panier.quantite)
    end
    @ventes = @vente.vente_point.ventes
    @ventes_panier = @ventes.select { |vente| vente.paniers.any? }
    @ventes_moins_un = @ventes_panier.select { |vente| vente.date < @vente.date }
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
      redirect_to vente_paniers_path(@vente)
    else
      render :new
    end
  end

  def edit
    @vente = Vente.find(params[:vente_id])
    @pointdevente = @vente.vente_point
    @panier = Panier.find(params[:id])
  end

  def update
    @vente = Vente.find(params[:vente_id])
    @pointdevente = @vente.vente_point
    @panier = Panier.find(params[:id])
    if @panier.update(panier_params)
      flash[:notice] = "Panier modifié avec succès !"
      redirect_to vente_paniers_path(@vente)
    else
      render :edit
    end
  end

private

  def panier_params
    params.require(:panier).permit(:prix_ttc, :quantite, :vente_id, :valide)
  end

end
