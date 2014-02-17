class Authentication::ResetPasswordsController < ApplicationController
  def new
    redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?
  end

  def create
    return redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?

    @user = User.find_by_email(params[:email])
    @user.update_attributes(reset_password_token: "abcdef123")
    AuthenticationMailer.reset_password(@user).deliver
    flash[:notice] = t("authentication.notice.successfully_sent_reset_password_email")
    render :new
  end

  def edit
    return redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?

    if !params[:token]
      redirect_to reset_password_path, alert: t("authentication.alert.no_reset_password_token")
    elsif !User.find_by_reset_password_token(params[:token])
      redirect_to reset_password_path, alert: t("authentication.alert.invalid_reset_password_token")
    end
  end

  def update
    return redirect_to root_path, alert: t("authentication.alert.authenticated_sign_out_try_again") if signed_in?

    @user = User.find_by_reset_password_token(params[:token])
    if @user
      cookies[:user_id] = @user.id
      @user.update_attributes(password: params[:password])
      flash[:notice] = t("authentication.notice.successfully_reset_password")
      render :edit
    elsif params[:token]
      redirect_to reset_password_path, alert: t("authentication.alert.invalid_reset_password_token")
    else
      redirect_to reset_password_path, alert: t("authentication.alert.no_reset_password_token")
    end
  end

  private def signed_in?
    cookies[:user_id]
  end
end
