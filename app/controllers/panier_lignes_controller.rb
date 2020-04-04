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
    @lignedepanier = PanierLigne.new(prixunitairettc: prixunitairettc, quantite: quantite, panier_id: panier_id, legume_id: legume)

    if @lignedepanier.save
      if @panier.prix_reel_ttc.nil?
        sommettc = 0
      else
        sommettc = @panier.prix_reel_ttc
      end
      sommettc += (@lignedepanier.quantite * @lignedepanier.prixunitairettc)
      @panier.prix_reel_ttc = sommettc
      @panier.save
      flash[:notice] = "Ligne créée avec succès !"
      redirect_to vente_paniers_path(@vente)
    else
      render :new
    end
  end

  def destroy
    @lignedepanier = PanierLigne.find(params[:id])
    @panier = @lignedepanier.panier
    @pointdevente = @panier.vente.vente_point
    @lignedepanier.destroy
    @panier.prix_reel_ttc -= (@lignedepanier.quantite * @lignedepanier.prixunitairettc)
    @panier.save
    redirect_to vente_point_path(@pointdevente)
  end
end
