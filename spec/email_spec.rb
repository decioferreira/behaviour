require_relative "../lib/email"

describe Email, "#valid?" do
  describe "valid emails" do
    it "nice and simple example" do
      email = Email.new("niceandsimple@example.com")
      expect(email.valid?).to be(true)
    end
  end

  describe "invalid emails" do
    it "an @ character must separate the local and domain parts" do
      email = Email.new("Abc.example.com")
      expect(email.valid?).to be(false)
    end
  end
end
