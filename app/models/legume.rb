class Legume < ApplicationRecord
  has_many :activites
  has_many :planches, through: :activites
  has_many :commentaires, through: :activites
  has_many :vente_lignes
  has_many :ventes, through: :vente_lignes
  has_many :panier_lignes
  has_many :paniers, through: :panier_lignes
  has_many :ventes, through: :panier_lignes
  has_many :previsionnel_planches
  has_one_attached :photo
  belongs_to :familles_legume, optional: true
  serialize :total_legume_semaine, Hash
  serialize :commentaires_legume, Hash

  extend FriendlyId
  friendly_id :legume_css, use: :slugged
  validates :famille, presence: true
  validates :nom, presence: true
  validates :legume_css, presence: true
  validates :prix_general, presence: true

  def self.add_famille_reference
    Legume.all.each do |legume|
      fam = FamillesLegume.where("lower(nom) = ?", legume.famille.downcase).first.id
      legume.update!(familles_legume_id: fam)
    end
  end

  def self.add_total_to_legume
    Legume.all.each do |legume|
      total_legume = 0
      VenteLigne.where(legume_id: legume.id).each do |venteligne|
        total_legume += (venteligne.prixunitairettc * venteligne.quantite)
      end

      PanierLigne.joins(:panier).where(paniers: { valide: true }).where(legume_id: legume.id).each do |panierligne|
        total_panier = panierligne.prixunitairettc * panierligne.quantite * panierligne.panier.quantite
        total_legume += total_panier
      end
      legume.update(total_ttc_legume: total_legume)
    end
  end

  def self.add_total_legume_semaine_to_legume
    @week = Date.today.strftime("%W").to_i + 1
    @weeks = (1..@week).to_a.reverse
    @lignesdevente = VenteLigne.all
    @lignesdepanier = PanierLigne.all

    Legume.all.each do |legume|
      @weeks.reverse_each do |week|
        totauxlegume = 0
        @lignesdevente.select { |ligne| ligne.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
          totauxlegume += ligne.prixunitairettc * ligne.quantite
        end
        @lignesdepanier.select { |lignedepanier| lignedepanier.panier.valide == true }.select { |ligne| ligne.panier.vente.date.strftime("%W").to_i + 1 == week && ligne.legume == legume }.each do |ligne|
          totauxlegume += ligne.prixunitairettc * ligne.quantite * ligne.panier.quantite
        end
        legume.total_legume_semaine[week] = totauxlegume
        legume.save
      end
    end
  end

  def self.add_commentaires_to_legume
    @activites = Activite.all
    self.all.each do |legume|
      commentaires_leg = @activites.where("legume_id = ?", legume.id).map do |activite|
        if activite.commentaires.first.description != ""
          legume.commentaires_legume[activite.date] = activite.commentaires.first.description
          legume.save
        else
          legume.commentaires_legume = {}
          legume.save
        end
      end
    end
  end


end

