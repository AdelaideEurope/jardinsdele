class LegumesController < ApplicationController
  def index
    @legumes = Legume.all
    @commentaires = Commentaire.all
    @activites = Activite.all
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
  end

  def show
    @legume = Legume.find(params[:id])
    @activites = Activite.all
  end

end
