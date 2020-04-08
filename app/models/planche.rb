class Planche < ApplicationRecord
  has_many :activites
  has_many :vente_lignes
  has_many :panier_lignes
end
