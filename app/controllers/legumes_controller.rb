class LegumesController < ApplicationController
  def index
    @legumes = Legume.all
    @commentaires = Commentaire.all
    @activites = Activite.all
  end

  def recap
    @legumes = Legume.all
    @activites = Activite.all
  end
end


