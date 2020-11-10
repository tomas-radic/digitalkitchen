class Part < ApplicationRecord

  belongs_to :food
  has_many :ingredients, dependent: :destroy
  has_many :raws, through: :ingredients


  validates :name, :description,
            presence: true
  validates :position,
            presence: true, uniqueness: { scope: :food }


  acts_as_list scope: :food
end
