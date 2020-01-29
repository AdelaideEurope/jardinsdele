class VentesController < ApplicationController
  def index
    @ventes = Vente.all
    @pointsdevente = VentePoint.all
  end

  def show
    @vente = Vente.find(params[:id])
    @lignesdevente = @vente.vente_lignes
    sommeventettc = []
    sommeventeht = []
    @lignesdevente.each do |lignedevente|
      @puht = lignedevente.prixunitaireht
      @puttc = ht_to_ttc(@puht)
      @ptht = @puht * lignedevente.quantite
      sommeventeht << @ptht
      @ptttc = @puttc * lignedevente.quantite
      sommeventettc << @ptttc
    @sommeventettc = sommeventettc.sum
    @sommeventeht = sommeventeht.sum
    end
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
    @premierevente = Vente.first
    @lignesdevente = @premierevente.vente_lignes
    sommeventettc = []
    sommeventeht = []
    @lignesdevente.each do |lignedevente|
      @puht = lignedevente.prixunitaireht
      @puttc = ht_to_ttc(@puht)
      @ptht = @puht * lignedevente.quantite
      sommeventeht << @ptht
      @ptttc = @puttc * lignedevente.quantite
      sommeventettc << @ptttc
    @sommeventettc = sommeventettc.sum
    @sommeventeht = sommeventeht.sum
    end
  end

private

  def vente_params
    params.require(:vente).permit(:date, :vente_point_id)
  end

  def ttc_to_ht(prix)
    prix - (prix * 5.5.fdiv(100))
  end

  def ht_to_ttc(prix)
    prix + (prix * 5.5.fdiv(100))
  end

end
