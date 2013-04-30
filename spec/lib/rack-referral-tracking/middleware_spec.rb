require_relative '../../spec_helper'

describe Rack::ReferralTracking::Middleware do
  include Rack::Test::Methods

  describe 'basic Rack compliance' do
    let(:app) do
      inner_app = lambda { |env|
        [200, {'Content-Type' => 'text/plain'}, ["OK"]]
      }
      Rack::Lint.new(Rack::ReferralTracking::Middleware.new(inner_app))
    end

    it 'passes all Lint checks' do
      env = Rack::MockRequest.env_for('/')
      app.call(env)
    end
  end

  describe 'with referral metadata' do
    let(:app) do
      inner_app = lambda { |env|
        [200, {'Content-Type' => 'text/plain'}, ["OK"]]
      }
      Rack::ReferralTracking::Middleware.new(inner_app)
    end

    before { clear_cookies }

    it 'stores utm_campaign in a cookie' do
      get 'http://blog.example.com/?utm_campaign=launch'
      get 'http://id.example.com/signup'

      last_request.cookies.must_equal 'utm_campaign' => 'launch'
    end

    it 'stores utm_source in a cookie' do
      get 'http://blog.example.com/?utm_source=twitter'
      get 'http://id.example.com/signup'

      last_request.cookies.must_equal 'utm_source' => 'twitter'
    end

    it 'stores utm_medium in a cookie' do
      get 'http://blog.example.com/?utm_medium=email'
      get 'http://id.example.com/signup'

      last_request.cookies.must_equal 'utm_medium' => 'email'
    end
  end

end
