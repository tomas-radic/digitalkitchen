class Users::FoodsController < Users::BaseController

  include Users::FoodsHelper

  before_action :load_record, only: [:show]

  def index
    @records = Pundit.policy_scope!(current_user, Food)
                   .includes(:category, :raws)

    apply_filter! if params[:filter]
    @records = @records.sample(1000)
  end

  def show
    @user_raws = current_user.raws
    @user_ownerships = current_user.ownerships
  end


  private

  def load_record
    @record = Pundit.policy_scope!(current_user, Food).find(params[:id])
  end

  def apply_filter!
    if listing_available_foods?
      @records = AvailableFoods.call(
          user: current_user,
          foods: @records)
    elsif listing_owner_foods?
      @records = @records.where(owner: current_user)
    end
  end

end
