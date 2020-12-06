class ApplicationController < ActionController::Base
  include Pundit

  before_action :load_categories

  def after_sign_in_path_for(resource)
    foods_path
  end

  def after_sign_out_path_for(resource)
    foods_path
  end

  def switch_ownership
    if @ownership
      @ownership.update!(need_buy: !@ownership.need_buy)
    else
      current_user.ownerships.create!(raw: @raw, need_buy: false)
    end

    @ownerships = current_user.ownerships
  end

  private

  def load_categories
    @categories = FoodCategory.all
  end
end
