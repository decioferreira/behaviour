module Behaviour
  module Generators
    class AuthenticationGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def default_url_options
        application(nil, env: "test") do
          %Q{config.action_mailer.default_url_options = { host: "example.com" }}
        end
      end

      def cucumber_setup
        generate "cucumber:install"
      end

      def rspec_setup
        generate "rspec:install"
      end

      def copy_spec_files
        directory "spec"
      end

      def copy_feature_files
        directory "features"
      end
    end
  end
end
