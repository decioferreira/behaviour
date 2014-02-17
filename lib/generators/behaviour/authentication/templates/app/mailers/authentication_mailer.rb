class AuthenticationMailer < ActionMailer::Base
  default from: "from@example.com"

  def reset_password(user)
    @link = reset_password_edit_url(token: user.reset_password_token)
    mail(to: user.email, subject: "Website - password reset")
  end
end
