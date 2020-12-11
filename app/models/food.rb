class Food < ApplicationRecord

  include CloudPhoto

  belongs_to :owner, class_name: "User", optional: true
  belongs_to :food_category, foreign_key: :category_id
  belongs_to :proposal, optional: true
  has_many :parts, dependent: :destroy
  has_many :ingredients, through: :parts
  has_many :alternatives, through: :ingredients
  has_many :raws, through: :ingredients


  validates :name, presence: true

end
