require "test_helper"
require "generators/behaviour/authentication/authentication_generator"

class AuthenticationGeneratorTest < Rails::Generators::TestCase
  tests Behaviour::Generators::AuthenticationGenerator
  destination File.expand_path("../../../../../tmp", __FILE__)

  setup do
    prepare_destination
    prepare_dummy_app
    run_generator
  end

  test "all app tests pass" do
    system("cucumber #{destination_root}/features --color --out #{destination_root}/cucumber.log")
    assert_equal 0, $?.exitstatus, IO.read("#{destination_root}/cucumber.log")

    system("rspec #{destination_root} -I #{destination_root}/spec -o #{destination_root}/rspec.log --tty")
    assert_equal 0, $?.exitstatus, IO.read("#{destination_root}/rspec.log")
  end

  private def prepare_dummy_app
    FileUtils.cp_r("test/dummy/.", destination_root)
  end
end
