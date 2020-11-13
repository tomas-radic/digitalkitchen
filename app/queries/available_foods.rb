class AvailableFoods < ApplicationQuery

  def initialize(user)
    @user = user
  end

  def call
    foods = Pundit.policy_scope!(@user, Food).sample(1000)

    available_food_ids = foods.map do |food|
      food.id if food.ingredients.must_have.all? do |ingredient|
        ingredient.raws.find do |raw|
          @user.raws_having.include? raw
        end
      end
    end.compact

    Food.find available_food_ids
  end
end
