class FoodsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  include FoodsHelper

  before_action :load_food, only: [:show]

  def index
    @foods = policy_scope(Food)
                 .includes(:food_category, :raws)

    @heading = "Všetky jedlá"
    apply_filter! if params[:filter]
    @limit = 30
    @foods = @foods.order("RANDOM()").limit(@limit).reorder(created_at: :desc)
    @total_count = @foods.count
  end

  def show
    @arranged_raws = ArrangedRaws.call(@food)
    @ownerships = current_user.ownerships.to_a if current_user
  end


  def switch_ownership
    @food = policy_scope(Food).find(params[:food_id])
    raw = policy_scope(Raw).find(params[:raw_id])
    ownership = current_user.ownerships.find_by(raw: raw)

    if ownership
      ownership.update!(need_buy: !ownership.need_buy)
    else
      current_user.ownerships.create!(raw: raw, need_buy: false)
    end

    @ownerships = current_user.ownerships.to_a
    @arranged_raws = ArrangedRaws.call(@food)

    respond_to do |format|
      format.js
    end
  end


  private

  def load_food
    @food = policy_scope(Food).find(params[:id])
  end

  def apply_filter!
    params[:filter] ||= {}

    search_filter = params.dig(:filter, :search)

    if search_filter
      # -- NOTE: unaccent search --
      # Ruby: I18n.transliterate("Hé les mecs!")
      # SQL: select name from foods where unaccent(name) ilike '%marina%';

      search_filter = I18n.transliterate(search_filter).split(/\s+/).map(&:downcase)
      @foods = @foods.where("unaccent(lower(foods.name)) ~* ?", search_filter.join('|')) # (any of values divided by pipe)
      @heading = "Výsledky hľadania"
    else
      list_filter = params.dig(:filter, :list)

      category = FoodCategory.find_by(id: list_filter)

      if category
        @foods = @foods.where(food_category: category)
        @heading = category.name
      elsif user_signed_in?
        if list_filter == "mine"
          @foods = @foods.where(owner: current_user)
          @heading = "Moje jedlá"
        elsif list_filter == "liked"
          # TODO: filter user liked foods
          @heading = "Obľúbené jedlá"
        end
      end

      if user_signed_in? && params.dig(:filter, :available) == "true"
        @foods = AvailableFoods.call(
            user: current_user,
            foods: @foods)
      end
    end

    # params[:filter].delete_if { |key, value| value.blank? }
    # params.delete(:filter) if params[:filter].blank?
  end

end
