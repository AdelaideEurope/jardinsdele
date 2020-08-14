class ChartsController < ApplicationController
  def ca_legume_semaine
    @legumes = Legume.all
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @legumes_semaines_graph = @legumes.map { |legume| { name: legume.nom, legume_css: legume.legume_css, data: legumes_semaines_graph(legume), famille_legume: legume.familles_legume.nom.downcase.tr("é", "e") } }.sort_by { |hashlegume| -hashlegume[:name].tr("É", "E") }
    @familles = FamillesLegume.all
    @familles_couleurs = Hash.new
    @familles.each do |famille|
      @familles_couleurs[famille.nom] = famille.couleur
    end

    @colors = []
    @legumes_semaines_graph.each do |legume|
      @colors << @familles_couleurs[legume[:famille_legume]]
    end
    @colors

    render json: @legumes_semaines_graph
  end

private

  def legumes_semaines_graph(legume)
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @arr_weeks = []
    @weeks.reverse_each do |week|
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
