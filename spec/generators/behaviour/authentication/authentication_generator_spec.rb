require "spec_helper"
require "generators/behaviour/authentication/authentication_generator"

describe Behaviour::Generators::AuthenticationGenerator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../../tmp", __FILE__)

  before do
    prepare_destination
    FileUtils.cp_r "spec/dummy/.", destination_root
  end

  describe "no arguments" do
    before { run_generator }

    describe "features" do
      it { expect(file("features/authentication/reset_password.feature")).to exist }
      it { expect(file("features/authentication/sign_in.feature")).to exist }
      it { expect(file("features/authentication/sign_out.feature")).to exist }
      it { expect(file("features/authentication/sign_up.feature")).to exist }
      it { expect(file("features/authentication/update_account.feature")).to exist }

      it { expect(file("features/step_definitions/authentication.rb")).to exist }

      it { expect(file("features/support/authentication.rb")).to exist }
      it { expect(file("features/support/i18n.rb")).to exist }
      it { expect(file("features/support/rspec_syntax.rb")).to exist }
      it { expect(file("features/support/show_me_the_cookies.rb")).to exist }
    end

    describe "specs" do
      it { expect(file("spec/controllers/authentication/reset_passwords_controller_spec.rb")).to exist }
      it { expect(file("spec/controllers/authentication/sessions_controller_spec.rb")).to exist }
      it { expect(file("spec/controllers/authentication/users_controller_spec.rb")).to exist }

      it { expect(file("spec/support/i18n.rb")).to exist }
      it { expect(file("spec/support/syntax.rb")).to exist }
    end
  end
end
