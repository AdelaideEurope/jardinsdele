class PanierLigne < ApplicationRecord
  belongs_to :panier
  belongs_to :legume
  validates :prixunitairettc, presence: true
  validates :quantite, presence: true
  validates :legume, presence: true
end
