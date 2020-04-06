class Vente < ApplicationRecord
  belongs_to :vente_point, optional: true
  has_many :vente_lignes, dependent: :destroy
  has_many :paniers, dependent: :destroy
  has_many :panier_lignes, through: :paniers
  validates :date, presence: true
  validates :vente_point, presence: true
end
