class Memo < ApplicationRecord
  validates :date, presence: true
  validates :categorie, presence: true
end
