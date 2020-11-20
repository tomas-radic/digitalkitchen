class Alternative < ApplicationRecord

  acts_as_list scope: :ingredient

  belongs_to :ingredient
  belongs_to :raw


  validates :position, uniqueness: { scope: :ingredient_id }

end
