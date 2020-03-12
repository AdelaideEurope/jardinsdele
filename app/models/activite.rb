class Activite < ApplicationRecord
  belongs_to :planche, optional: true
  belongs_to :legume, optional: true
  belongs_to :assistant, optional: true
  has_many :commentaires, dependent: :destroy
  accepts_nested_attributes_for :commentaires
  validates :date, presence: true
  validates :nom, presence: true
  acts_as_taggable
  validate :end_date_after_start_date?

  def end_date_after_start_date?
    if heure_fin < heure_debut
      errors.add :heure_fin, ": doit être après l'heure de début"
    end
  end

  def duree_activite(activite)
    activite.heure_fin - activite.heure_debut
  end
end
