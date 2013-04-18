# Rack::Referral::Tracking

Rack middleware that detects requests from a referral and places some details
about the referral in a user's cookies.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-referral-tracking'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-referral-tracking

## Usage

Set a secure secret in your environment:

    $ export REFERRAL_SECRET=50mJn9wvwAXtQ28obpwxD7uMcqJRUquFz+GMRGDB4ZU=

Then in your Rack-based application:

    use Rack::ReferralTracking::Middleware

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
