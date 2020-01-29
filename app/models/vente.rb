class Vente < ApplicationRecord
  belongs_to :vente_point, optional: true
  has_many :vente_lignes
  validates :date, presence: true
  validates :vente_point, presence: true
end
