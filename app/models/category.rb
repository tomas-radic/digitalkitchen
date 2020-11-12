class Category < ApplicationRecord

  has_many :foods, dependent: :restrict_with_error
  has_many :raws, dependent: :nullify

  validates :name, presence: true
end
