class Users::FoodsController < Users::BaseController

  include Users::FoodsHelper

  before_action :load_food, only: [:show]

  def index
    @foods = Pundit.policy_scope!(current_user, Food)
                   .includes(:food_category, :raws)

    apply_filter! if params[:filter]
    @foods = @foods.sample(1000)
  end

  def show
    @ownerships = current_user.ownerships.to_a
  end


  def switch_ownership
    raw = Raw.find(params[:raw_id])
    @ownership = current_user.ownerships.find_by(raw: raw)

    super

    @ownerships = @ownerships.to_a
    @food = Pundit.policy_scope!(current_user, Food).find(params[:food_id])

    respond_to do |format|
      format.js
    end
  end


  private

  def load_food
    @food = Pundit.policy_scope!(current_user, Food).find(params[:id])
  end

  def apply_filter!
    if listing_available_foods?
      @foods = AvailableFoods.call(
          user: current_user,
          foods: @foods)
    elsif listing_owner_foods?
      @foods = @foods.where(owner: current_user)
    end
  end

end
