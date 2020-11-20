class Part < ApplicationRecord

  acts_as_list scope: :food

  belongs_to :food
  has_many :ingredients, dependent: :destroy
  has_many :raws, through: :ingredients


  validates :name, :description,
            presence: true
  validates :position,
            uniqueness: { scope: :food }



end
