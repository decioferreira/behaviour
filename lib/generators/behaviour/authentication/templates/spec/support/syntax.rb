# Source: http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax#configuration_options
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
