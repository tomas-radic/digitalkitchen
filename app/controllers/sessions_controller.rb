class SessionsController < Devise::SessionsController

  def new
    if flash[:alert]
      if flash[:alert] == "Invalid Email or password."
        flash[:danger] = "Email/heslo je nesprávne."
      end

      flash.delete(:alert)
    end

    super
    flash.delete(:notice)
  end

  def create
    super
    flash.delete(:notice)
  end

  def destroy
    super
    flash.delete(:notice)
  end
end
