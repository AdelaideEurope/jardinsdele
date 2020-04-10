class VentesController < ApplicationController
  def index
    @ventes = Vente.all
    @pointsdevente = VentePoint.all
    @ventes_semaine = @ventes.group_by { |m| m.date.strftime("%W").to_i + 1 }
    @ventes_mois = @ventes.group_by { |m| m.date.month }
    @week = Date.today.strftime("%W").to_i + 1
    @ventes_futures = @ventes.select { |vente| vente.date > Date.today }.sort_by(&:date).reverse
    @month = Date.today.month
  end

  def show
    @vente = Vente.find(params[:id])
    @lignedevente = VenteLigne.new
    @lignesdevente = @vente.vente_lignes
    @paniers = Panier.all.where(vente_id: @vente.id).select { |panier| panier.valide == true }
    @planches = Planche.all
    @jardins = @planches.group_by { |planche| planche.jardin }
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
    @week = Date.today.strftime("%W").to_i + 1
    @ventes_semaine = @ventes.select { |m| m.date.strftime("%W").to_i + 1 == @week }
    @monthtoday = Date.today.month
    @ventes_mois = @ventes.select { |m| m.date.month == @monthtoday }
    @catotal = @ventes.map(&:total_ttc).sum
    @paniers = @pointsdevente.map { |pointdevente| pointdevente.panier_ids }.flatten
    @ventes_panier = @ventes.select { |vente| vente.paniers.any? && vente.date >= Date.today }
    @pointsdevente_panier = @pointsdevente.select { |pointdevente| pointdevente.paniers.any? }
    @pointsdevente_ac_panier = Hash.new { |h, k| h[k] = "".to_i }
    @pointsdevente_panier.each do |pointdevente|
      @pointsdevente_ac_panier[pointdevente.nom] = pointdevente.id
    end
  end

  def update
    @vente = Vente.find(params[:id])
    montant_regle = params[:vente][:montant_regle]
    montant_arrondi = params[:vente][:montant_arrondi]
    if montant_regle.nil? || montant_regle == ""
      if @vente.update(montant_arrondi: montant_arrondi)
        flash[:notice] = "Montant arrondi renseigné avec succès !"
        redirect_to vente_path(@vente)
      end
    elsif montant_arrondi.nil? || montant_regle == ""
      if @vente.update(montant_regle: montant_regle)
        flash[:notice] = "Montant réglé renseigné avec succès !"
        redirect_to vente_path(@vente)
      end
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
