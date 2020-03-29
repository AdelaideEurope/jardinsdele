class Vente < ApplicationRecord
  belongs_to :vente_point, optional: true
  has_many :vente_lignes
  has_many :paniers, dependent: :destroy
  validates :date, presence: true
  validates :vente_point, presence: true
end
