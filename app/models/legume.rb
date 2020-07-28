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

end

