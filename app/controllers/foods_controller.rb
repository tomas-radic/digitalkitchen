class FoodsController < ApplicationController

  before_action :load_food, only: [:show]

  def index
    redirect_to users_foods_path and return if user_signed_in?

    @foods = Food.publicly_visible
                 .includes(:food_category, :raws)

    @heading = "Všetky jedlá"
    apply_filter! if params[:filter]
    @total_count = @foods.count
    @limit = 30
    @foods = @foods.order("RANDOM()").limit(@limit)
  end

  def show
    redirect_to users_food_path(@food) and return if user_signed_in?

    @arranged_raws = ArrangedRaws.call(@food)
  end

  private

  def load_food
    @food = Food.publicly_visible.find(params[:id])
  end

  def apply_filter!
    params[:filter] ||= {}

    list_filter = params.dig(:filter, :list)

    category = FoodCategory.find_by(id: list_filter)

    if category
      @foods = @foods.where(food_category: category)
      @heading = category.name
    end
  end
end
