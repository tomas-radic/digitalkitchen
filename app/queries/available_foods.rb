class AvailableFoods < BaseQuery

  def initialize(user:, foods:)
    @user = user
    @foods = foods
  end

  def call
    user_raws = @user.raws_having

    available_food_ids = @foods.includes(:raws).map do |food|
      if food.ingredients.must_have.all? { |ingredient| (user_raws & ingredient.raws).any? }
        food.id
      end
    end.compact

    Food.where id: available_food_ids
  end
end
