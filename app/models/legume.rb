class Legume < ApplicationRecord
  has_many :activites
  has_many :planches, through: :activites
  has_many :commentaires, through: :activites
  has_many :vente_lignes
  has_many :ventes, through: :vente_lignes
  extend FriendlyId
  friendly_id :legume_css, use: :slugged
end
