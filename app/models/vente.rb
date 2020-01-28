class Vente < ApplicationRecord
  belongs_to :vente_point, optional: true
end
