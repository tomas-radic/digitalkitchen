class Part < ApplicationRecord

  belongs_to :food
  has_many :ingredients, dependent: :destroy
  has_many :raws, through: :ingredients


  validates :name, :position, :description,
            presence: true
end
