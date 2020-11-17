class Ownership < ApplicationRecord

  before_validation :set_defaults


  belongs_to :user
  belongs_to :raw


  validates :raw_id, uniqueness: { scope: :user_id }


  scope :holding, -> { where(need_buy: false) }
  scope :need_buy, -> { where(need_buy: true) }


  private

  def set_defaults
    self.need_buy ||= false
  end

end
