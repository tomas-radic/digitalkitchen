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
    @arranged_raws = ArrangedRaws.call(@food)
    @ownerships = current_user.ownerships.to_a
  end


  def switch_ownership
    @raw = Raw.find(params[:raw_id])
    @ownership = current_user.ownerships.find_by(raw: @raw)

    super

    @ownerships = @ownerships.to_a
    @food = Pundit.policy_scope!(current_user, Food).find(params[:food_id])
    @arranged_raws = ArrangedRaws.call(@food)

    respond_to do |format|
      format.js
    end
  end


  private

  def load_food
    @food = Pundit.policy_scope!(current_user, Food).find(params[:id])
  end

  def apply_filter!
    params[:filter] ||= {}

    list_filter = params.dig(:filter, :list)

    if list_filter == "mine"
      @foods = @foods.where(owner: current_user)
    elsif list_filter == "liked"
      # TODO: filter user liked foods
    end

    if params.dig(:filter, :available) == "true"
      @foods = AvailableFoods.call(
          user: current_user,
          foods: @foods)
    end

    category_filter = params.dig(:filter, :category_id)

    if category_filter
      @foods = @foods.where(category_id: category_filter)
    end

    # params[:filter].delete_if { |key, value| value.blank? }
    # params.delete(:filter) if params[:filter].blank?
  end

end
