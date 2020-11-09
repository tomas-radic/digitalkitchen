class Food < ApplicationRecord

  belongs_to :category, polymorphic: true, optional: true
  has_many :parts, dependent: :destroy
  has_many :ingredients, through: :parts
  has_many :raws, through: :ingredients


  validates :name, presence: true

end
