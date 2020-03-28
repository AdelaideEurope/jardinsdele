class Legume < ApplicationRecord
  has_many :activites
  has_many :planches, through: :activites
  has_many :commentaires, through: :activites
  has_many :vente_lignes
  has_many :ventes, through: :vente_lignes
  has_one_attached :photo
  extend FriendlyId
  friendly_id :legume_css, use: :slugged
  validates :famille, presence: true
  validates :nom, presence: true
  validates :legume_css, presence: true
  validates :prix_general, presence: true
end
