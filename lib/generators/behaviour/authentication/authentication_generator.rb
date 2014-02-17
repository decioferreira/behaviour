module Behaviour
  module Generators
    class AuthenticationGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def default_url_options
        application(nil, env: "test") do
          %Q{config.action_mailer.default_url_options = { host: "example.com" }\n}
        end
      end

      # Implementation
      def copy_app_files
        directory "app"
      end

      def generate_user_model
        generate "model", "user email:string password:string reset_password_token:string --no-test-framework"
        rake "db:migrate"
      end

      def copy_locale_files
        directory "config/locales"
      end

      def add_routes
        route <<-EOS.gsub(/\A {8}|^ {6}/, "")
        scope module: "authentication" do
          get "sign_in" => "sessions#new"
          post "sign_in" => "sessions#create"

          get "sign_up" => "users#new"
          post "sign_up" => "users#create"

          get "account/edit" => "users#edit"
          post "account/edit" => "users#update"

          get "reset_password" => "reset_passwords#new"
          post "reset_password" => "reset_passwords#create"

          get "reset_password/edit" => "reset_passwords#edit"
          patch "reset_password/edit" => "reset_passwords#update"

          delete "sign_out" => "sessions#destroy"
        end
        EOS
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
