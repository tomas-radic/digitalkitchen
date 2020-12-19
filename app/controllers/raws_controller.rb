class RawsController < ApplicationController

  before_action :authenticate_user!

  def index
    @raws = Raw.regular
    @ownerships = current_user.ownerships.to_a
  end


  def create
    @raw = CreateUserRaw.call(
        params[:raw][:name],
        category_id: params[:raw][:category_id],
        user: current_user)

    @raws = Raw.regular
    @ownerships = current_user.ownerships.to_a

    respond_to do |format|
      format.js
    end
  end


  def switch_ownership
    @raws = Raw.regular
    raw = @raws.find(params[:raw_id])
    ownership = current_user.ownerships.find_by(raw: raw)

    if ownership
      ownership.update!(need_buy: !ownership.need_buy)
    else
      current_user.ownerships.create!(raw: raw, need_buy: false)
    end

    @ownerships = current_user.ownerships.to_a

    respond_to do |format|
      format.js
    end
  end


  def create_ownership
    @raws = Raw.regular
    raw = @raws.find(params[:ownership][:raw_id])
    current_user.ownerships.where(raw: raw, need_buy: true).first_or_create!

    @ownerships = current_user.ownerships.to_a

    respond_to do |format|
      format.js
    end
  end
end
