class RawsController < ApplicationController

  before_action :authenticate_user!

  def index
    @raws = Raw.all
    @ownerships = current_user.ownerships.to_a
  end

  def switch_ownership
    raw = Raw.find(params[:raw_id])
    ownership = current_user.ownerships.find_by(raw: raw)

    if ownership
      ownership.update!(need_buy: !ownership.need_buy)
    else
      current_user.ownerships.create!(raw: raw, need_buy: false)
    end

    @ownerships = current_user.ownerships.to_a
    @raws = Raw.all

    respond_to do |format|
      format.js
    end
  end

end
