class Proposal < ApplicationRecord
  extend Enumerize
  include CloudPhoto

  enumerize :status, with: %i(open closed)


  validates :name, :ingredients, :description,
            presence: true


  belongs_to :user
  has_one :food, dependent: :nullify
end
