class LegumesController < ApplicationController
  def index
    @legumes = Legume.all
  end
end
