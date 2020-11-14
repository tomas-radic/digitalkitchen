class Users::OwnershipsController < Users::BaseController

  def index
    @records = current_user.ownerships
    @raws = Raw.all
  end

  def create
    @raw = Raw.find(params[:raw_id])
    current_user.ownerships.where(raw: @raw).first_or_create

    @user_raw_ids = current_user.raws.ids
    @record_raw_ids = Food.find(params[:food_id]).raws.ids

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @raw = Raw.find(params[:raw_id])
    current_user.ownerships.find_by(raw: @raw)&.destroy

    @user_raw_ids = current_user.raws.ids
    @record_raw_ids = Food.find(params[:food_id]).raws.ids

    respond_to do |format|
      format.js
    end
  end
end
