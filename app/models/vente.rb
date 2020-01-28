class Vente < ApplicationRecord
  belongs_to :vente_point, optional: true
  validates :date, presence: true
  validates :vente_point, presence: true
end
