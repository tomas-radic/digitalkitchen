class User < ApplicationRecord

  has_many :foods, dependent: :nullify
  has_many :ownerships, dependent: :destroy
  has_many :raws, through: :ownerships


  validates :email, :name,
            presence: true,
            uniqueness: true
end
