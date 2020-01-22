class Legume < ApplicationRecord
  has_many :activites
  has_many :planches, through: :activites
  has_many :commentaires, through: :activites
end
