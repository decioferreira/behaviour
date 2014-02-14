class Authentication::UsersController < ApplicationController
  def new
    redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?
  end

  def create
    return redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?

    if User.find_by_email(params[:email])
      flash[:alert] = t("authentication.alert.already_registered")
      render :new
    else
      user = User.create(email: params[:email], password: params[:password])
      cookies[:user_id] = user.id
      redirect_to root_path, notice: t("authentication.notice.successfully_signed_up")
    end
  end

  def edit
    redirect_to root_path, alert: t("authentication.alert.unauthenticated_user") unless signed_in?
  end

  def update
    return redirect_to root_path, alert: t("authentication.alert.unauthenticated_user") unless signed_in?

    user = User.find(cookies[:user_id])
    user.update_attributes(password: params[:password])

    if params[:current_password] == ""
      flash[:alert] = t("authentication.alert.current_password_required")
    else
      flash[:notice] = t("authentication.notice.successfully_updated_account")
    end

    render :edit
  end

  private def signed_in?
    cookies[:user_id]
  end
end
