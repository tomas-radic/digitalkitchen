class Administration::UsersController < Administration::BaseController

  def index
    @users = User.all
  end

end
