class Ingredient < ApplicationRecord

  belongs_to :part
  has_many :alternatives, dependent: :destroy
  has_many :raws, through: :alternatives


  scope :must_have, -> { where(optional: false) }


  def name
    self.raws.map(&:name).join(" alebo ")
  end

end
