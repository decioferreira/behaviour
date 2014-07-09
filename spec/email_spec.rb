shared_examples "an email address" do
  describe "#valid?" do
    describe "valid email addresses" do
      %w(
        niceandsimple@example.com
        very.common@example.com
        a.little.lengthy.but.fine@dept.example.com
        disposable.style.email.with+symbol@example.com
        other.email-with-dash@example.com
        user@localserver
      ).each do |valid_email|
        it valid_email do
          expect(described_class.new(valid_email).valid?).to be(true)
        end
      end
    end

    describe "invalid email addresses" do
      {
        "Abc.example.com" => "an @ character must separate the local and domain parts",
        "A@b@c@example.com" => "only one @ is allowed outside quotation marks",
        "a\"b(c)d,e:f;g<h>i[j\\k]l@example.com" => "none of the special characters in this local part is allowed outside quotation marks",
        "just\"not\"right@example.com" => "quoted strings must be dot separated, or the only element making up the local-part",
        "this is\"not\\allowed@example.com" => "spaces, quotes, and backslashes may only exist when within quoted strings and preceded by a backslash",
        "this\\ still\\\"not\\\\allowed@example.com" => "even if escaped (preceded by a backslash), spaces, quotes, and backslashes must still be contained by quotes"
      }.each do |invalid_email, explanation|
        it "#{invalid_email} (#{explanation})" do
          expect(described_class.new(invalid_email).valid?).to be(false)
        end
      end
    end
  end
end

require_relative "../lib/email"

describe Email do
  it_behaves_like "an email address"
end
