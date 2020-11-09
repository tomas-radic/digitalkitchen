class Users::BaseController < ApplicationController

  # TEMPORARY while log in not implemented
  def current_user
    User.find_by!(email: "tomas.radic@gmail.com")
  end
end
