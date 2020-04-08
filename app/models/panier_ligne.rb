class PanierLigne < ApplicationRecord
  belongs_to :panier
  belongs_to :legume
  belongs_to :planche, optional: true
  validates :prixunitairettc, presence: true
  validates :quantite, presence: true
  validates :legume, presence: true
end
