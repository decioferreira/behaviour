class Authentication::SessionsController < ApplicationController
  def new
    redirect_to root_path, alert: t("authentication.alert.already_authenticated") if signed_in?
  end

  def create
    return redirect_to root_path, alert: t("authentication.alert.already_authenticated") if signed_in?

    user = User.find_by_email(params[:email])

    if user
      if user.password == params[:password]
        if params[:remember_me]
          cookies.permanent[:user_id] = user.id
        else
          cookies[:user_id] = user.id
        end
        return redirect_to root_path, notice: t("authentication.notice.successfully_signed_in")
      else
        flash[:alert] = t("authentication.alert.invalid_password")
      end
    else
      flash[:alert] = t("authentication.alert.invalid_email")
    end

    render :new
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to root_path, notice: t("authentication.notice.successfully_signed_out")
  end

  private def signed_in?
    cookies[:user_id]
  end
end
