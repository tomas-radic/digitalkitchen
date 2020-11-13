class Category < ApplicationRecord

  validates :name, presence: true, uniqueness: { scope: :type }

end
