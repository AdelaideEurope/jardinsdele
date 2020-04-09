class VenteLignesController < ApplicationController
  def index
    @lignesdevente = VenteLigne.all
  end

  def new
    @vente = Vente.find(params[:vente_id])
    @lignedevente = VenteLigne.new
    @legumes = Legume.all
    @sorted_legumes = @legumes.sort_by(&:legume_css)
    @firsthalf = (@sorted_legumes.length/2.to_f).ceil
    @secondhalf = @sorted_legumes.length/2
    @activites = Activite.all
    planches = Planche.all
    @jardins = planches.group_by(&:jardin)
  end

  def create
    @lignedevente = VenteLigne.new(lignedevente_params)
    @vente = Vente.find(params[:vente_id])
    @lignedevente.vente = @vente
    @pointdevente = VentePoint.find(@vente.vente_point_id)
    unite = params[:vente_ligne][:unite].nil? ? Legume.find(params[:vente_ligne][:legume_id]).unite : params[:vente_ligne][:unite]
    if @lignedevente.save
      if @vente.total_ht.nil?
        sommeht = 0
        sommettc = 0
      else
        sommeht = @vente.total_ht
        sommettc = @vente.total_ttc
      end
      if @pointdevente.total_ht.nil?
        sommepdvht = 0
        sommepdvttc = 0
      else
        sommepdvht = @pointdevente.total_ht
        sommepdvttc = @pointdevente.total_ttc
      end
      sommeht += @lignedevente.totalht
      sommettc += @lignedevente.totalttc
      @vente.total_ht = sommeht
      @vente.total_ttc = sommettc
      sommepdvht += @lignedevente.totalht
      sommepdvttc += @lignedevente.totalttc
      @pointdevente.total_ht = sommepdvht
      @pointdevente.total_ttc = sommepdvttc
      @pointdevente.save
      @vente.save
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
      :totalttc,
      :planche_id)
  end
end
