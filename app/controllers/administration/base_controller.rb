class Administration::BaseController < ApplicationController
  layout "administration"

  before_action :authenticate_user!
  before_action :verify_admin!


  private

  def verify_admin!
    redirect_to root_path and return unless current_user.admin?
  end
end
