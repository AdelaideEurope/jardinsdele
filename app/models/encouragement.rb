class Encouragement < ApplicationRecord
  validates :message, presence: true
  validates :auteur, presence: true
end
