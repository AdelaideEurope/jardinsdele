class VenteLignesController < ApplicationController
  def index
    @lignesdevente = VenteLigne.all
  end

  def new
    @vente = Vente.find(params[:vente_id])
    @pointdevente = @vente.vente_point
    @lignedevente = VenteLigne.new
    @lignesdevente = VenteLigne.all
    @legumes = Legume.all
    @sorted_legumes = @legumes.sort_by(&:legume_css)
    @firsthalf = (@sorted_legumes.length/2.to_f).ceil
    @secondhalf = @sorted_legumes.length/2
    @activites = Activite.all
    planches = Planche.all
    @jardins = planches.group_by(&:jardin)

    @legumes_last_prix = ""
    @legumes.each do |legume|
      unless @lignesdevente.where(legume_id: legume.id).select {|ligne| ligne.vente.vente_point == @pointdevente}.empty?
        @legumes_last_prix << "#{legume.id}, #{@lignesdevente.where(legume_id: legume.id).reverse.detect {|ligne| ligne.vente.vente_point == @pointdevente}.prixunitaireht.to_s}, "
      end
    end
    @legumes_last_prix = @legumes_last_prix[0...-2]
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

  def edit
    @vente = Vente.find(params[:vente_id])
    @lignedevente = VenteLigne.find(params[:id])
    @pointdevente = VentePoint.find(@vente.vente_point_id)
    @legumes = Legume.all
    @sorted_legumes = @legumes.sort_by(&:legume_css)
    @firsthalf = (@sorted_legumes.length/2.to_f).ceil
    @secondhalf = @sorted_legumes.length/2
    @activites = Activite.all
    planches = Planche.all
    @jardins = planches.group_by(&:jardin)
    @vente.total_ttc -= @lignedevente.totalttc
    @vente.total_ht -= @lignedevente.totalht
    @pointdevente.total_ttc -= @lignedevente.totalttc
    @pointdevente.total_ht -= @lignedevente.totalht
    @vente.save
    @pointdevente.save
  end

  def update
    @vente = Vente.find(params[:vente_id])
    @lignedevente = VenteLigne.find(params[:id])
    @pointdevente = VentePoint.find(@vente.vente_point_id)
    planche = params[:vente_ligne][:planche_id]
    legume = params[:vente_ligne][:legume_id]
    quantite = params[:vente_ligne][:quantite]
    prixunitairettc = params[:vente_ligne][:prixunitairettc]
    prixunitaireht = params[:vente_ligne][:prixunitaireht]
    totalttc = params[:vente_ligne][:totalttc]
    totalht = params[:vente_ligne][:totalht]
    unite = params[:vente_ligne][:unite]
    if planche.nil?
      if @lignedevente.update(legume_id: legume, quantite: quantite, prixunitairettc: prixunitairettc, prixunitaireht: prixunitaireht, totalht: totalht, totalttc: totalttc, unite: unite)
        @vente.total_ttc += @lignedevente.totalttc
        @vente.total_ht += @lignedevente.totalht
        @pointdevente.total_ttc += @lignedevente.totalttc
        @pointdevente.total_ht += @lignedevente.totalht
        @vente.save
        @pointdevente.save
        flash[:notice] = "Ligne modifiée avec succès !"
        redirect_to vente_path(@vente)
      else
        render :edit
      end
    else @lignedevente.update(planche_id: planche)
        flash[:notice] = "Planche modifiée avec succès !"
        redirect_to vente_path(@vente)
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
      :planche_id,
      :unite)
  end
end
