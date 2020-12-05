class Users::UsersController < Users::BaseController

  def edit
  end

  def update
    success_msg = "Profil bol úspešne upravený."
    failure_msg = "Profil sa nepodarilo upraviť!"

    if changing_password?
      if current_user.update_with_password(whitelisted_params)
        flash[:success] = success_msg
        bypass_sign_in(current_user)
        redirect_to root_path and return
      else
        flash.now[:danger] = failure_msg
        render :edit and return
      end
    end
    if current_user.update_without_password(whitelisted_params.except("current_password"))
      flash[:success] = success_msg
      redirect_to root_path and return
    else
      flash.now[:danger] = failure_msg
      render :edit and return
    end
  end


  private

  def whitelisted_params
    if changing_password?
      params.require(:user).permit(:name, :current_password, :password, :password_confirmation)
    else
      params.require(:user).permit(:name)
    end
  end

  def changing_password?
    !params[:user][:current_password].blank? &&
        !params[:user][:password].blank? &&
        !params[:user][:password_confirmation].blank?
  end

end
