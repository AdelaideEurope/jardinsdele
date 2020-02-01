class VentesController < ApplicationController
  def index
    @ventes = Vente.all
    @pointsdevente = VentePoint.all
  end

  def show
    @vente = Vente.find(params[:id])
    @lignedevente = VenteLigne.new
    @lignesdevente = @vente.vente_lignes
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
    @lignesdevente = VenteLigne.all
    @week = Date.today.strftime("%W").to_i+1
    @ventes_semaine = @ventes.select { |m| m.date.strftime("%W").to_i + 1 == @week }
    @monthtoday = Date.today.month
    @ventes_mois = @ventes.select { |m| m.date.month == @monthtoday }
    @catotal = @ventes.map(&:total_ttc).sum
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
