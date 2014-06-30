ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'r18n-core'

require 'mail'

Mail.defaults do
  delivery_method :test
end

Capybara.app = Sinatra::Application

#Capybara.default_driver = :selenium
#R18n.set('en')

class AppWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
  include R18n::Helpers
end

World { AppWorld.new }
