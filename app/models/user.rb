class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :foods, dependent: :nullify
  has_many :ownerships, dependent: :destroy
  has_many :raws, through: :ownerships
  has_many :raws_having, -> { where("ownerships.need_buy is false") }, through: :ownerships, source: :raw
  has_many :raws_to_buy, -> { where("ownerships.need_buy is true") }, through: :ownerships, source: :raw
  has_many :proposals, dependent: :destroy


  validates :email, :name,
            presence: true,
            uniqueness: true
end
