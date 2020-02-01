class VenteLigne < ApplicationRecord
  belongs_to :vente
  belongs_to :legume, optional: true
  belongs_to :planche, optional: true
end
