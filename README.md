# Behaviour (alpha version)

Behaviour generates the tests you need, to implement new features from scratch on your application.

Currently, there is only one feature available: user authentication.

## About

Behaviour is a first attempt to rething the way we develop gems.

Instead of extending your code with the implementation for a new feature, the behaviour gem gives you the tests needed to confidently develop the new functionality.

Some of the advantages of this approach are:

* Learn by example, great source of community written tests
* Flexibility, easily adapt the generated tests to match the functionality wanted
* Testing, helps you writing tests for your application
* Freedom, to discover new ways of implementing features, and to adapt it to your own style/project
* Adaptable/dynamic, be in control of what features to implement, and how to implement them

## Installation

Add this line to your application's Gemfile:

    gem 'behaviour', group: [:development, :test]

Or you can add the latest build:

    gem 'behaviour', git: 'git://github.com/decioferreira/behaviour.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install behaviour

## Usage

To generate the features and specs for the user authentication system run:

    $ rails generate behaviour:authentication

## Contributing

1. Fork it ( http://github.com/decioferreira/behaviour/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
