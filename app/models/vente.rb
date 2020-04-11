class Vente < ApplicationRecord
  belongs_to :vente_point, optional: true
  has_many :vente_lignes, dependent: :destroy
  has_many :paniers, dependent: :destroy
  has_many :panier_lignes, through: :paniers
  has_many :commentaires, dependent: :destroy
  validates :date, presence: true
  validates :vente_point, presence: true

  def resteapercevoir
    sommeapercevoir = []
    if montant_arrondi.nil? || montant_arrondi == 0
      sommeapercevoir << (total_ttc - montant_regle)
    else
      sommeapercevoir << montant_arrondi - montant_regle
    end
    @sommeapercevoir = sommeapercevoir.sum
  end
end


