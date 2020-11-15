class RawCategory < Category

  has_many :raws, dependent: :nullify, foreign_key: :category_id
  has_many :ingredients, dependent: :nullify, foreign_key: :category_id

end
