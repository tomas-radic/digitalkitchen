class Category < ApplicationRecord

  validates :name, presence: true, uniqueness: { scope: :type }


  scope :sorted, -> { order(:name) }

end
