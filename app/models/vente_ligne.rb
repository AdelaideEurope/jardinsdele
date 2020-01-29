class VenteLigne < ApplicationRecord
  belongs_to :vente
  belongs_to :legume, optional: true
end
