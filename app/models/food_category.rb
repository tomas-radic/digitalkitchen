class FoodCategory < Category

  has_many :foods, dependent: :restrict_with_error, foreign_key: :category_id

end
