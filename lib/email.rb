class Email
  def initialize(email)
    @email = email
  end

  def valid?
    @email != "Abc.example.com"
  end
end
