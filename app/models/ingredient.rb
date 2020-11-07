class Ingredient < ApplicationRecord

  belongs_to :part
  has_many :alternatives, dependent: :destroy
  has_many :raws, through: :alternatives

end
