class PlanchesController < ApplicationController
  def index
    @planches = Planche.all
    @previsionnel_planches = PrevisionnelPlanch.all
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @ventes = Vente.all
    @legumes = Legume.all

    @planches_legumes = @planches.map do |planche|
      { planche: planche.nom, legumes: legumes_planches(planche) }
    end
  end

  def legumes_planches(planche)
    legumes = []
    @lignesdepanier.select { |lignedepanier| lignedepanier.planche == planche }.each do |lignedepanier|
      legumes << { nom: lignedepanier.legume.nom, total: total_legume(lignedepanier.legume, planche), previ: previ_planche(lignedepanier.legume, planche), diff: total_legume(lignedepanier.legume, planche) - previ_planche(lignedepanier.legume, planche), pourcentage_previ: pourcentage_previ(lignedepanier.legume, planche) }
    end
    @lignesdevente.select { |lignedevente| lignedevente.planche == planche }.each do |lignedevente|
      legumes << { nom: lignedevente.legume.nom, total: total_legume(lignedevente.legume, planche), previ: previ_planche(lignedevente.legume, planche), diff: total_legume(lignedevente.legume, planche) - previ_planche(lignedevente.legume, planche), pourcentage_previ: pourcentage_previ(lignedevente.legume, planche) }
    end
    legumes.uniq
  end

  def total_legume(legume, planche)
    @lignesdevente.select { |lignedevente| lignedevente.planche == planche && lignedevente.legume == legume }.map {|ligne| ligne.quantite * ligne.prixunitairettc }.sum + @lignesdepanier.select { |lignedepanier| lignedepanier.planche == planche && lignedepanier.legume == legume }.map {|ligne| ligne.quantite * ligne.prixunitairettc }.sum
  end

  def previ_planche(legume, planche)
    previ_planche = @previsionnel_planches.select { |previ| previ.planche == planche && previ.legume == legume }&.first&.total_previ
    previ_planche.nil? ? 0 : previ_planche
  end

  def pourcentage_previ(legume, planche)
    return 0 if total_legume(legume, planche).nil? || previ_planche(legume, planche).nil? || total_legume(legume, planche).zero? || previ_planche(legume, planche).zero?

    total_legume(legume, planche) * 100 / previ_planche(legume, planche)
  end
end
