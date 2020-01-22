class Activite < ApplicationRecord
  belongs_to :planche, optional: true
  belongs_to :legume, optional: true
  belongs_to :assistant, optional: true
  has_many :commentaires, dependent: :destroy
  accepts_nested_attributes_for :commentaires
  validates :date, presence: true
  validates :nom, presence: true
  acts_as_taggable
end
