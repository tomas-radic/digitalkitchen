class Ownership < ApplicationRecord

  belongs_to :user
  belongs_to :raw

end
