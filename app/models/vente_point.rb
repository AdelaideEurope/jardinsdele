class VentePoint < ApplicationRecord
  has_many :ventes
  has_many :paniers, through: :ventes
end
