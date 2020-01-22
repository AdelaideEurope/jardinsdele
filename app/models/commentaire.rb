class Commentaire < ApplicationRecord
  belongs_to :activite, optional: true
  validates_presence_of :activite
end
