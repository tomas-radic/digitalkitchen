module FoodsHelper

  def about_text(food)
    food.description.presence || food.ingredients.map(&:name).join(' - ')
  end


  def list_available?
    params[:filter] == "available"
  end


  def list_mine?
    params[:filter] == "mine"
  end
end
