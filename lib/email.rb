class Email
  def initialize(email)
    @email = email
  end

  def valid?
    return false if @email.count("@") != 1
    return false if @email.count("\"") > 0
    true
  end
end
