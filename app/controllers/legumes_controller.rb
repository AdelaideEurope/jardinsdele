class LegumesController < ApplicationController
  def index
    @legumes = Legume.all
    @commentaires = Commentaire.all
    @activites = Activite.all
    @lignesdevente = VenteLigne.all
  end

  def new
    @legume = Legume.new
  end

  def create
    @legume = Legume.new(legume_params)
    if @legume.save
      flash[:notice] = "Légume créé avec succès !"
      redirect_to legumes_path
    else
      render :new
    end
  end

  def edit
    @legume = Legume.friendly.find(params[:id])
  end

  def update
    @legume = Legume.friendly.find(params[:id])
    if @legume.update(legume_params)
      flash[:notice] = "Légume modifié avec succès !"
      redirect_to legumes_path
    else
      render :edit
    end
  end

  def recap
    @legumes = Legume.all
    @activites = Activite.all
    @planches_a = Planche.first(20)
    @planches_b = Planche.all[20..39]
    @planches_c = Planche.all[40..59]
    @planches_d = Planche.all[60..64]
    @planches_e = Planche.all[65..69]
    @planches_f = Planche.all[70..74]
    @lignesdevente = VenteLigne.all
  end

  def show
    @legume = Legume.friendly.find(params[:id])
    @activites = Activite.where(["legume_id = ?", @legume.id])
    @lignesdeventeparlegume = VenteLigne.where(["legume_id = ?", @legume.id])
    @ventes = Vente.all
    @catotal = @ventes.map(&:total_ttc).sum
  end

  def legume_params
    params.require(:legume).permit(:nom, :legume_css, :prix_general)
  end

end

