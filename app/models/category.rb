class Category < ApplicationRecord

  has_many :categorizables, as: :category, dependent: :nullify


  validates :name, :type,
            presence: true
end
