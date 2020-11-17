class Users::RawsController < Users::BaseController

  def index
    @raws = Raw.all
    @ownerships = current_user.ownerships.to_a
  end

  def switch_ownership
    @raw = Raw.find(params[:raw_id])
    @ownership = current_user.ownerships.find_by(raw: @raw)

    super

    @ownerships = @ownerships.to_a
    @raws = Raw.all

    respond_to do |format|
      format.js
    end
  end

end
