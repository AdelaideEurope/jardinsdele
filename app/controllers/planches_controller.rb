class PlanchesController < ApplicationController
  def index
    @planches = Planche.all
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all
    @ventes = Vente.all
    @lignesgroupees = Hash.new { |hash, key| hash[key] = "".to_f }
    @planches.each do |planche|
      @lignesdepanier.select { |lignedepanier| lignedepanier.planche == planche }.each do |lignedepanier|
        @lignesgroupees[planche] += lignedepanier.prixunitairettc * lignedepanier.quantite * lignedepanier.panier.quantite
      end
      @lignesdevente.select { |lignedevente| lignedevente.planche == planche }.each do |lignedevente|
        @lignesgroupees[planche] += (lignedevente.prixunitairettc) * (lignedevente.quantite)
      end
    end
    @catotal = @ventes.map(&:total_ttc).sum
  end
end
