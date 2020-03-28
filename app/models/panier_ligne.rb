class PanierLigne < ApplicationRecord
  belongs_to :panier
  belongs_to :legume
end
