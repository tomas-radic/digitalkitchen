class User < ApplicationRecord

  has_many :foods, dependent: :nullify
  has_many :ownerships, dependent: :destroy
  has_many :raws, through: :ownerships
  has_many :raws_having, -> { where("ownerships.need_buy is false") }, through: :ownerships, source: :raw
  has_many :raws_to_buy, -> { where("ownerships.need_buy is true") }, through: :ownerships, source: :raw


  validates :email, :nickname,
            presence: true,
            uniqueness: true
end
