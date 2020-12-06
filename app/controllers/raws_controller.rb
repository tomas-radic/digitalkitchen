class RawsController < ApplicationController

  before_action :authenticate_user!

  def index
    @raws = Raw.all
    @ownerships = current_user.ownerships.to_a
  end

  def switch_ownership
    @raw = Pundit.policy_scope!(current_user, Raw).find(params[:raw_id])
    @ownership = current_user.ownerships.find_by(raw: @raw)

    super

    @ownerships = @ownerships.to_a
    @raws = Pundit.policy_scope!(current_user, Raw).distinct.order(:name)

    respond_to do |format|
      format.js
    end
  end

end
