class ApplicationController < ActionController::Base
  include Pundit

  # TODO: TEMPORARY
  helper_method :current_user
  def current_user
    User.first
  end
end
