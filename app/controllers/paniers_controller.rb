class PaniersController < ApplicationController
  def show
    @vente = Vente.find(params[:vente_id])
    @panier = Panier.find(params[:id])
    @lignesdepanier = PanierLigne.all.where(panier_id: @panier.id)
  end

  def index
    @vente = Vente.find(params[:vente_id])
    @paniers = @vente.paniers
    @lignesdepanier = @vente.panier_lignes
    @lignesdepanier_all = PanierLigne.all
    @pointdevente = @vente.vente_point
    @arecolter = Hash.new { |arecolter, legume| arecolter[legume] = { unite: "", quantite: "".to_f } }
    @lignesdepanier.sort_by(&:legume).each do |ligne|
      @arecolter[ligne.legume.nom][:unite] = ligne.unite.nil? || ligne.unite == "" ? ligne.legume.unite : ligne.unite
      @arecolter[ligne.legume.nom][:quantite] += (ligne.quantite * ligne.panier.quantite)
    end
    @ventes = @vente.vente_point.ventes
    @ventes_panier = @ventes.select { |vente| vente.paniers.any? }
    @ventes_moins_un = @ventes_panier.select { |vente| vente.date < @vente.date }

    @ecarts = Hash.new { |ecart, prixpanier| ecart[prixpanier] = "".to_i }
    @pointdevente.paniers.where("valide = ? AND engagement = ?", true, true).each do |panier|
      @ecarts[panier.prix_ttc] += ((panier.prix_reel_ttc || 0.00) - panier.prix_ttc)
    end
    @legumes = Legume.all
    @sorted_legumes = @legumes.sort_by(&:legume_css)
    @firsthalf = (@sorted_legumes.length/2.to_f).ceil
    @secondhalf = @sorted_legumes.length/2
    @lignedepanier = PanierLigne.new

    @legumes_last_prix_paniers = ""
    @legumes.each do |legume|
      unless @lignesdepanier_all.where(legume_id: legume.id).select {|ligne| ligne.panier.vente.vente_point == @pointdevente}.empty?
        @legumes_last_prix_paniers << "#{legume.id}, #{@lignesdepanier_all.where(legume_id: legume.id).select {|ligne| ligne.panier.vente.vente_point == @pointdevente}.last.prixunitairettc.to_s}, "
      end
    end
    @legumes_last_prix_paniers = @legumes_last_prix_paniers[0...-2]

    @legumes_last_paniers = ""
    @legumes.each do |legume|
      if @lignesdepanier_all.where(legume_id: legume.id).select {|ligne| ligne.panier.vente.vente_point == @pointdevente}.empty?
        @legumes_last_paniers << "#{legume.id}, na ,"
      else
        date_raw = @lignesdepanier_all.where(legume_id: legume.id).select {|ligne| ligne.panier.vente.vente_point == @pointdevente}.last.panier.vente.date.to_s
        date = "#{date_raw[8..9]}#{date_raw[5..6]}"
        @legumes_last_paniers << "#{legume.id},#{date},"
      end
    end
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
    engagement = params[:panier][:engagement]
    @panier = Panier.new(prix_ttc: prix_ttc, quantite: quantite, vente_id: vente_id, engagement: engagement)
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
    @lignesdepanier = @panier.panier_lignes
    sommelignesttc = @lignesdepanier.map{|ligne|ligne.quantite * ligne.prixunitairettc}.sum.round(2)
    @panier.prix_reel_ttc = sommelignesttc
    if @panier.update(panier_params)
      if params[:panier][:valide] == "true"
        params[:panier][:prix_reel_ttc] = sommelignesttc
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
        sommeht += ttc_to_ht(@panier.prix_ttc) * @panier.quantite
        sommettc += @panier.prix_ttc * @panier.quantite
        @vente.total_ht = sommeht
        @vente.total_ttc = sommettc
        sommepdvht += ttc_to_ht(@panier.prix_ttc) * @panier.quantite
        sommepdvttc += @panier.prix_ttc * @panier.quantite
        @pointdevente.total_ht = sommepdvht
        @pointdevente.total_ttc = sommepdvttc
        @pointdevente.save
        @vente.save

        flash[:notice] = "Panier validé avec succès !"
        redirect_to vente_paniers_path(@vente)
      else
        flash[:notice] = "Panier modifié avec succès !"
        redirect_to vente_paniers_path(@vente)
      end
    else
      render :edit
    end
  end

private

  def panier_params
    params.require(:panier).permit(:prix_ttc, :totalttc, :quantite, :vente_id, :valide, :engagement)
  end

  def ttc_to_ht(prix)
    prix - (prix * 5.5.fdiv(100))
  end
end
