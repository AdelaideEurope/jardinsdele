class ChartsController < ApplicationController
  def ca_legume_semaine
    @legumes = Legume.all
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @legumes_semaines_graph = @legumes.map { |legume| { name: legume.nom, legume_css: legume.legume_css, data: legumes_semaines_graph(legume), famille: legume.famille.downcase.tr("é", "e") } }.sort_by { |hashlegume| -hashlegume[:name].tr("É", "E") }
    familles_colors = { "alliacees" => "#FF6600", "apiacees" => "#99CC33", "asteracees" => "#CC0000", "brassicacees" => "#33CCFF", "chenopodacees" => "#FFCC00", "cucurbitacees" => "#660099", "divers" => "#990000", "fabacees" => "#006633", "solanacees" => "#009999" }

    @colors = []
    @legumes_semaines_graph.each do |legume|
      @colors << familles_colors[legume[:famille]]
    end

    render json: @legumes_semaines_graph
  end

private

  def legumes_semaines_graph(legume)
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @arr_weeks = []
    @weeks.reverse.each do |week|
      totauxlegume = 0
      @lignesdevente.select { |ligne| ligne.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite
      end
      @lignesdepanier.select { |lignedepanier| lignedepanier.panier.valide == true }.select { |ligne| ligne.panier.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
        totauxlegume += ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite
      end
      @arr_weeks << [week, totauxlegume]
    end
    @arr_weeks
  end

end
