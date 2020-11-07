class Part < ApplicationRecord

  belongs_to :food
  has_many :steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy


  validates :name, :sequence,
            presence: true
end
