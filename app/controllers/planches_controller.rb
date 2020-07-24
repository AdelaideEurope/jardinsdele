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

    @legumes_planches = @legumes.map do |legume|
      { legume: legume.nom, legume_css: legume.legume_css, planches: planches_legume(legume) }
    end
  end

  def legumes_planches(planche)
    legumes = []
    @lignesdepanier.where(planche: planche).includes(:legume).each do |lignedepanier|
      legumes << { nom: lignedepanier.legume.nom, total: total_legume(lignedepanier.legume, planche), previ: previ_planche(lignedepanier.legume, planche), diff: total_legume(lignedepanier.legume, planche) - previ_planche(lignedepanier.legume, planche), pourcentage_previ: pourcentage_previ(lignedepanier.legume, planche) }
    end
    @lignesdevente.where(planche: planche).includes(:legume).each do |lignedevente|
      legumes << { nom: lignedevente.legume.nom, total: total_legume(lignedevente.legume, planche), previ: previ_planche(lignedevente.legume, planche), diff: total_legume(lignedevente.legume, planche) - previ_planche(lignedevente.legume, planche), pourcentage_previ: pourcentage_previ(lignedevente.legume, planche) }
    end
    legumes.uniq
  end

  def planches_legume(legume)
    planches = []
    @lignesdepanier.includes(:planche, :legume).where(legume: legume).where.not(planche: nil?).each do |lignedepanier|
      planches << { nom: lignedepanier.planche.nom, total: total_planche(legume, lignedepanier.planche), previ: previ_legume(lignedepanier.planche, legume), diff: total_planche(legume, lignedepanier.planche) - previ_legume(lignedepanier.planche, legume), pourcentage_previ: pourcentage_previ(legume, lignedepanier.planche) }
    end
    @lignesdevente.includes(:planche, :legume).where(legume: legume).where.not(planche: nil?).each do |lignedevente|
      planches << { nom: lignedevente.planche.nom, total: total_planche(legume, lignedevente.planche), previ: previ_legume(lignedevente.planche, legume), diff: total_planche(legume, lignedevente.planche) - previ_legume(lignedevente.planche, legume), pourcentage_previ: pourcentage_previ(legume, lignedevente.planche) }
    end
    planches.uniq
  end

  def total_legume(legume, planche)
    @lignesdevente.includes(:planche, :legume).where(legume: legume).where(planche: planche).map {|ligne| ligne.quantite * ligne.prixunitairettc }.sum + @lignesdepanier.includes(:planche, :legume).where(legume: legume).where(planche: planche).map {|ligne| ligne.quantite * ligne.prixunitairettc * ligne.panier.quantite }.sum
  end

  def total_planche(legume, planche)
    @lignesdevente.includes(:planche, :legume).where(legume: legume).where(planche: planche).map {|ligne| ligne.quantite * ligne.prixunitairettc }.sum + @lignesdepanier.includes(:planche, :legume).where(legume: legume).where(planche: planche).map {|ligne| ligne.quantite * ligne.prixunitairettc * ligne.panier.quantite }.sum
  end

  def previ_planche(legume, planche)
    previ_planche = @previsionnel_planches.includes(:planche, :legume).where(planche: planche).where(legume: legume)&.first&.total_previ
    previ_planche.nil? ? 0 : previ_planche
  end

  def previ_legume(planche, legume)
    previ_legume = @previsionnel_planches.includes(:planche, :legume).where(planche: planche).where(legume: legume)&.first&.total_previ
    previ_legume.nil? ? 0 : previ_legume
  end

  def pourcentage_previ(legume, planche)
    return 0 if total_legume(legume, planche).nil? || previ_planche(legume, planche).nil? || total_legume(legume, planche).zero? || previ_planche(legume, planche).zero?

    total_legume(legume, planche) * 100 / previ_planche(legume, planche)
  end
end
