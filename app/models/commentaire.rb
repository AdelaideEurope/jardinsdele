class Commentaire < ApplicationRecord
  belongs_to :activite, optional: true
  validates_presence_of :activite
  include PgSearch::Model
  pg_search_scope :global_search,
    against: [:description],
    associated_against: {
      activite: [:nom]
    },
    using: {
      tsearch: { prefix: true }
    }
end
