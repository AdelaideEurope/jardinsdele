class Panier < ApplicationRecord
  belongs_to :vente
  has_many :panier_lignes, dependent: :destroy
  validates :prix_ttc, presence: true
  validates :quantite, presence: true
end
