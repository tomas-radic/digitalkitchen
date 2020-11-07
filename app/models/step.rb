class Step < ApplicationRecord

  belongs_to :part


  validates :position, :description,
            presence: true

end
