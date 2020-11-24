class AvailableFoods < BaseQuery

  def initialize(user:, foods:)
    @user = user
    @foods = foods
  end

  def call
    user_raws = @user.raws_having.to_a

    available_food_ids = @foods.map do |food|
      if food.ingredients.must_have.all? { |ingredient| (user_raws & ingredient.raws).any? }
        food.id
      end
    end.compact

    Food.find available_food_ids
  end
end
