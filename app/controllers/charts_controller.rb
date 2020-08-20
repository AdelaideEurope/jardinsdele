class ChartsController < ApplicationController
  def ca_legume_semaine
    @legumes = Legume.all
    @legumes_semaines_graph = @legumes.sort_by(&:legume_css).map { |legume| { name: legume.nom, legume_css: legume.legume_css, data: legume.total_legume_semaine } }

    render json: @legumes_semaines_graph
  end

end
