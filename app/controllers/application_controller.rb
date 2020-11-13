class ApplicationController < ActionController::Base
  include Pundit

  # TODO: TEMPORARY
  def current_user
    User.first
  end
end
