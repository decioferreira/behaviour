# Behaviour (alpha version)

[![Build Status](https://travis-ci.org/decioferreira/behaviour.svg?branch=sinatra)](https://travis-ci.org/decioferreira/behaviour)

Behaviour gives you the tests you need, to implement new features from scratch on your application.

Currently, there is only one feature available: user authentication (w/ email validator).

## Development

    $ bundle install

### Run server

    $ rackup

### Run tests

To run all the tests:

    $ rake

Or you can run just Cucumber's features:

    $ cucumber

Or just RSpec:

    $ rspec

## Contributing

1. Fork it ( http://github.com/decioferreira/behaviour/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
