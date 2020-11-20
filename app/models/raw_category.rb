class RawCategory < Category

  has_many :raws, dependent: :nullify, foreign_key: :category_id

end
