class Panier < ApplicationRecord
  belongs_to :vente
  has_many :panier_lignes
end
