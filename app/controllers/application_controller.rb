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

  end

  private

  def load_categories
    @categories = FoodCategory.all
  end
end
