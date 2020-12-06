module FoodsHelper

  def food_about_text(food)
    food.description.presence || food.ingredients.map(&:name).join(' - ')
  end

end
