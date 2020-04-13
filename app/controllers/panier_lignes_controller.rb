class PanierLignesController < ApplicationController
  def index
    @panier = Panier.find(params[:panier_id])
    @lignes = PanierLigne.all.where(panier_id: @panier.id)
  end

  def new
    @vente = Vente.find(params[:vente_id])
    @panier = Panier.find(params[:panier_id])
    @pointdevente = @vente.vente_point
    @lignedepanier = PanierLigne.new
    @legumes = Legume.all
    @sorted_legumes = @legumes.sort_by(&:legume_css)
    @firsthalf = (@sorted_legumes.length/2.to_f).ceil
    @secondhalf = @sorted_legumes.length/2
  end

  def create
    @vente = Vente.find(params[:vente_id])
    @panier = Panier.find(params[:panier_id])
    @pointdevente = @vente.vente_point
    panier_id = params[:panier_id]
    prixunitairettc = params[:panier_ligne][:prixunitairettc]
    quantite = params[:panier_ligne][:quantite]
    legume = params[:panier_ligne][:legume_id]
    unite = params[:panier_ligne][:unite].empty? ? Legume.find(params[:panier_ligne][:legume_id]).unite : params[:panier_ligne][:unite]
    @lignedepanier = PanierLigne.new(prixunitairettc: prixunitairettc, quantite: quantite, panier_id: panier_id, legume_id: legume, unite: unite)

    if @lignedepanier.save
      flash[:notice] = "Ligne créée avec succès !"
      redirect_to vente_paniers_path(@vente)
    else
      render :new
    end
  end

  def edit
    @lignedepanier = PanierLigne.find(params[:id])
    @panier = Panier.find(params[:panier_id])
    @vente = Vente.find(params[:vente_id])
    @pointdevente = @vente.vente_point
    @legumes = Legume.all
    @sorted_legumes = @legumes.sort_by(&:legume_css)
    @firsthalf = (@sorted_legumes.length/2.to_f).ceil
    @secondhalf = @sorted_legumes.length/2
  end

  def update
    @vente = Vente.find(params[:vente_id])
    @panier = Panier.find(params[:panier_id])
    @pointdevente = @vente.vente_point
    panier_id = params[:panier_id]
    prixunitairettc = params[:panier_ligne][:prixunitairettc]
    quantite = params[:panier_ligne][:quantite]
    legume = params[:panier_ligne][:legume_id]
    @lignedepanier = PanierLigne.find(params[:id])
    planche = params[:panier_ligne][:planche_id]
    unite = params[:panier_ligne][:unite]
    if planche.nil?
      if @lignedepanier.update(prixunitairettc: prixunitairettc, quantite: quantite, panier_id: panier_id, legume_id: legume, planche_id: planche, unite: unite)
        flash[:notice] = "Ligne modifiée avec succès !"
        redirect_to vente_paniers_path(@vente)
      else
        render :edit
      end
    elsif @lignedepanier.update(planche_id: planche)
      flash[:notice] = "Planche ajoutée avec succès !"
      redirect_to vente_path(@vente)
    else
      render :edit
    end
  end

  def destroy
    @lignedepanier = PanierLigne.find(params[:id])
    @panier = @lignedepanier.panier
    @pointdevente = @panier.vente.vente_point
    @lignedepanier.destroy
    redirect_to vente_paniers_path(@panier.vente)
  end
end
