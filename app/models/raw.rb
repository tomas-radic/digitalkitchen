class Raw < ApplicationRecord

  belongs_to :category, polymorphic: true, optional: true
  has_many :alternatives, dependent: :restrict_with_error
  has_many :ownerships, dependent: :restrict_with_error


  validates :name,
            presence: true, uniqueness: true
end
