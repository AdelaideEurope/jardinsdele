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
      { legume: legume.nom, legume_css: legume.legume_css, planches: planches_legumes(legume) }
    end
  end

  def legumes_planches(planche)
    legumes = []
    @lignesdepanier.includes(:planche, :legume).where(planche: planche).each do |lignedepanier|
      unless legumes.any? {|hash| hash[:nom] == lignedepanier.legume.nom}
        totallegume = total_legume(lignedepanier.legume, planche)
        previlegume = previ_planche(lignedepanier.legume, planche)
        legumes << { nom: lignedepanier.legume.nom, total: totallegume, previ: previlegume, diff: totallegume - previlegume, pourcentage_previ: pourcentage_previ(lignedepanier.legume, planche) }
      end
    end
    @lignesdevente.includes(:planche, :legume).where(planche: planche).each do |lignedevente|
      unless legumes.any? {|hash| hash[:nom] == lignedevente.legume.nom}
        totallegume = total_legume(lignedevente.legume, planche)
        previlegume = previ_planche(lignedevente.legume, planche)
        legumes << { nom: lignedevente.legume.nom, total: totallegume, previ: previlegume, diff: totallegume - previlegume, pourcentage_previ: pourcentage_previ(lignedevente.legume, planche) }
      end
    end
    legumes
  end

  def planches_legumes(legume)
    planches = []
    @lignesdepanier.includes(:planche, :legume).where(legume: legume).where.not(planche: nil?).each do |lignedepanier|
      unless planches.any? {|hash| hash[:nom] == lignedepanier.planche.nom}
        totalplanche = total_planche(legume, lignedepanier.planche)
        previplanche = previ_planche(legume, lignedepanier.planche)
        planches << { nom: lignedepanier.planche.nom, total: totalplanche, previ: previplanche, diff: totalplanche - previplanche, pourcentage_previ: pourcentage_previ(legume, lignedepanier.planche) }
      end
    end
    @lignesdevente.includes(:planche, :legume).where(legume: legume).where.not(planche: nil?).each do |lignedevente|
      unless planches.any? {|hash| hash[:nom] == lignedevente.planche.nom}
        totalplanche = total_planche(legume, lignedevente.planche)
        previplanche = previ_planche(legume, lignedevente.planche)
        planches << { nom: lignedevente.planche.nom, total: totalplanche, previ: previplanche, diff: totalplanche - previplanche, pourcentage_previ: pourcentage_previ(legume, lignedevente.planche) }
      end
    end
    planches
  end

  def total_legume(legume, planche)
    sommelegume = 0
    @lignesdevente.includes(:planche, :legume).where(legume: legume).where(planche: planche).each {|ligne| sommelegume += (ligne.quantite * ligne.prixunitairettc) }
    @lignesdepanier.includes(:planche, :legume).where(legume: legume).where(planche: planche).each {|ligne| sommelegume += (ligne.quantite * ligne.prixunitairettc * ligne.panier.quantite) }
    sommelegume
  end

  def total_planche(legume, planche)
    sommeplanche = 0
    @lignesdevente.includes(:planche, :legume).where(legume: legume).where(planche: planche).each {|ligne| sommeplanche += (ligne.quantite * ligne.prixunitairettc)}
    @lignesdepanier.includes(:planche, :legume).where(legume: legume).where(planche: planche).each {|ligne| sommeplanche += (ligne.quantite * ligne.prixunitairettc * ligne.panier.quantite)}
    sommeplanche
  end

  def previ_planche(legume, planche)
    previ_planche = @previsionnel_planches.includes(:planche, :legume).where(planche: planche).where(legume: legume)
    previ_planche.nil? ? 0 : previ_planche

    previ_legume = @previsionnel_planches.includes(:planche, :legume).where(planche: planche).where(legume: legume)&.first&.total_previ
    previ_legume.nil? ? 0 : previ_legume
  end


  def pourcentage_previ(legume, planche)
    (total_legume(legume, planche) * 100 / previ_planche(legume, planche)).infinite? ? 0 : total_legume(legume, planche) * 100 / previ_planche(legume, planche)
  end
end
