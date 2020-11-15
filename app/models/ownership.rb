class Ownership < ApplicationRecord

  before_validation :set_defaults


  belongs_to :user
  belongs_to :raw


  scope :holding, -> { where(need_buy: false) }
  scope :need_buy, -> { where(need_buy: true) }


  private

  def set_defaults
    self.need_buy ||= false
  end

end
