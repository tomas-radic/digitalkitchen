class Users::OwnershipsController < Users::BaseController

  def index
    @records = current_user.ownerships
    @raws = Raw.all
  end

  def create
    current_user.ownerships.where(raw_id: params[:raw_id]).first_or_create

    @record = Pundit.policy_scope!(current_user, Food).find(params[:food_id])
    @user_raws = current_user.raws
    @user_ownerships = current_user.ownerships

    respond_to do |format|
      format.js
    end
  end

  def destroy
    current_user.ownerships.find(params[:id]).destroy

    @record = Pundit.policy_scope!(current_user, Food).find(params[:food_id])
    @user_raws = current_user.raws
    @user_ownerships = current_user.ownerships

    respond_to do |format|
      format.js
    end
  end
end
