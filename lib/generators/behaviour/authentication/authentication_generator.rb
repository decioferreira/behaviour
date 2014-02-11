module Behaviour
  module Generators
    class AuthenticationGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def gem_dependencies
        gem_group :development, :test do
          gem "rspec-rails", version: "~> 3.0.0.beta"
          gem "rack_session_access"
        end

        gem_group :test do
          gem "cucumber-rails", require: false
          gem "database_cleaner"
        end

        run "bundle install"
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
