class Ingredient < ApplicationRecord

  belongs_to :part
  belongs_to :raw_category, optional: true, foreign_key: :category_id
  has_many :alternatives, dependent: :destroy
  has_many :raws, through: :alternatives


  scope :must_have, -> { where(optional: false) }


  def name
    self.raws.map(&:name).join(" alebo ")
  end

end
