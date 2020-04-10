class Commentaire < ApplicationRecord
  belongs_to :activite, optional: true
  belongs_to :vente, optional: true
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
