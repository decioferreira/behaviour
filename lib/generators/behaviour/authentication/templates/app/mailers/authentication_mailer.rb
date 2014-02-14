class AuthenticationMailer < ActionMailer::Base
  default from: "from@example.com"

  def reset_password(user)
    @link = reset_password_edit_url(token: SecureRandom.hex(12))
    mail(to: user.email, subject: "Website password reset")
  end
end
