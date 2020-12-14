class Proposal < ApplicationRecord
  extend Enumerize
  include CloudPhoto

  enumerize :status, with: %i(open closed)


  validate :photo_size
  validates :name, :ingredients, :description,
            presence: true


  belongs_to :user
  has_one :food, dependent: :nullify

  attr_accessor :photo


  private

  def photo_size
    return unless photo
    errors[:photo] << "Prekročená maximálna veľkosť súboru" if photo.size > MAX_PHOTO_SIZE
  end
end
