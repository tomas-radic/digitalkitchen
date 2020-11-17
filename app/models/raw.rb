class Raw < ApplicationRecord

  belongs_to :raw_category, optional: true, foreign_key: :category_id
  has_many :ownerships, dependent: :restrict_with_error
  has_many :alternatives, dependent: :restrict_with_error


  validates :name,
            presence: true, uniqueness: true
end
