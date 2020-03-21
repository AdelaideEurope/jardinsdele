class Commentaire < ApplicationRecord
  belongs_to :activite, optional: true
  validates_presence_of :activite
  include PgSearch::Model
  pg_search_scope :search,
    against: [ :description ],
    using: {
      tsearch: { prefix: true }
    }
end

