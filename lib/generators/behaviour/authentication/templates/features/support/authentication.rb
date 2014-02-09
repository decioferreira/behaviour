module Authentication
  def user
    OpenStruct.new(
      email: "user@email.com",
      password: "password"
    )
  end

  def first_email
    ActionMailer::Base.deliveries.first
  end

  def reset_password_path_from_email(body)
    body.match(/https?:\/\/[^\/]+(\/reset\_password\/edit\?token=\h+)/)[1]
  end
end

World(Authentication)
