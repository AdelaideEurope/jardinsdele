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

end

