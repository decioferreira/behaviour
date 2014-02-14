class Authentication::ResetPasswordsController < ApplicationController
  def new
    redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?
  end

  def create
    return redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?

    user = User.find_by_email(params[:email])
    AuthenticationMailer.reset_password(user).deliver
    flash[:notice] = t("authentication.notice.successfully_sent_reset_password_email")
    render :new
  end

  def edit
    redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?
  end

  def update
    return redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?

    cookies[:user_id] = User.first.id
    flash[:notice] = t("authentication.notice.successfully_reset_password")
    render :edit
  end

  private def signed_in?
    cookies[:user_id]
  end
end
