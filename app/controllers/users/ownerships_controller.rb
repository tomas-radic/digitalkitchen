class Users::OwnershipsController < Users::BaseController

  before_action :load_ownership, only: [:update, :destroy]

  def index
    @ownerships = current_user.ownerships
    @raws = Raw.all
  end

  def create
    current_user.ownerships.create(whitelisted_params)

    @food = Pundit.policy_scope!(current_user, Food).find(params[:food_id])
    @user_ownerships = current_user.ownerships.holding

    respond_to do |format|
      format.js
    end
  end

  def update
    @ownership.update(whitelisted_params)

    @food = Pundit.policy_scope!(current_user, Food).find(params[:food_id])
    @user_ownerships = current_user.ownerships.holding

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @ownership.destroy

    @food = Pundit.policy_scope!(current_user, Food).find(params[:food_id])
    @user_ownerships = current_user.ownerships.holding

    respond_to do |format|
      format.js
    end
  end


  private

  def whitelisted_params
    params.require(:ownership).permit(:raw_id, :need_buy)
  end

  def load_ownership
    @ownership = current_user.ownerships.find(params[:id])
  end
end
