class Users::OwnershipsController < Users::BaseController

  before_action :load_ownership, only: [:update, :destroy]

  def index
    @ownerships = current_user.ownerships
  end

  def destroy
    @ownership.destroy
    @ownerships = current_user.ownerships

    respond_to do |format|
      format.js
    end
  end

  def switch_ownership
    @ownership = current_user.ownerships.find(params[:id])
    @raw = @ownership.raw

    super

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
