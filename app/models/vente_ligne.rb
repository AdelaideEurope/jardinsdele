class VenteLigne < ApplicationRecord
  belongs_to :vente
  belongs_to :legume, optional: true
  belongs_to :planche, optional: true
  validates :quantite, presence: true
  validates :prixunitaireht, presence: true
  validates :legume, presence: true
end
