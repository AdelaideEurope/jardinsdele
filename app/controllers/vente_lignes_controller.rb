class VenteLignesController < ApplicationController
  def index
    @lignesdevente = VenteLigne.all
  end

  def new
    @vente = Vente.find(params[:vente_id])
    @lignedevente = VenteLigne.new
  end

  def create
    @lignedevente = VenteLigne.new(lignedevente_params)
    @vente = Vente.find(params[:vente_id])
    @lignedevente.vente = @vente
    if @lignedevente.save
      flash[:notice] = "Ligne de vente créée avec succès !"
      redirect_to vente_path(@vente)
    else
      render :new
    end
  end

private

  def lignedevente_params
    params.require(:vente_ligne).permit(
      :vente_id,
      :legume_id,
      :quantite,
      :prixunitaireht,
      :prixunitairettc,
      :totalht,
      :totalttc)
  end

end
