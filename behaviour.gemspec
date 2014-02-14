# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "behaviour/version"

Gem::Specification.new do |spec|
  spec.name          = "behaviour"
  spec.version       = Behaviour::VERSION
  spec.authors       = ["Décio Ferreira"]
  spec.email         = ["decio.ferreira@decioferreira.com"]
  spec.summary       = %q{Specify your application's behaviour.}
  spec.description   = %q{Add new features to your application by specifying behaviour.}
  spec.homepage      = "https://github.com/decioferreira/behaviour"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec-rails", "~> 3.0.0.beta"
  spec.add_runtime_dependency "cucumber-rails"
  spec.add_runtime_dependency "database_cleaner"
  spec.add_runtime_dependency "show_me_the_cookies"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "sqlite3"
end
