class PlanchesController < ApplicationController
  def index
    @planches = Planche.all
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @ventes = Vente.all
    @lignesgroupees = Hash.new { |hash, key| hash[key] = {total: "".to_f, legumes: [] } }
    @planches.each do |planche|
      @lignesdepanier.select { |lignedepanier| lignedepanier.planche == planche }.each do |lignedepanier|
        @lignesgroupees[planche][:total] += lignedepanier.prixunitairettc * lignedepanier.quantite * lignedepanier.panier.quantite
        unless @lignesgroupees[planche][:legumes].include?(lignedepanier.legume.nom)
          @lignesgroupees[planche][:legumes] << lignedepanier.legume.nom
        end
      end
      @lignesdevente.select { |lignedevente| lignedevente.planche == planche }.each do |lignedevente|
        @lignesgroupees[planche][:total] += (lignedevente.prixunitairettc) * (lignedevente.quantite)
        unless @lignesgroupees[planche][:legumes].include?(lignedevente.legume.nom)
          @lignesgroupees[planche][:legumes] << lignedevente.legume.nom
        end
      end
    end
    @catotal = @ventes.map(&:total_ttc).sum
  end

  def previsionnel_planches
    @previsionnel_planches = PrevisionnelPlanche.all
  end
end
