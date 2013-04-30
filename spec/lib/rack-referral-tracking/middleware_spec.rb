require_relative '../../spec_helper'

describe Rack::ReferralTracking::Middleware do

  it 'passes all Lint checks' do
    app = lambda { |env|
      [200, {'Content-Type' => 'text/plain'}, ["OK"]]
    }

    app = Rack::Lint.new(Rack::ReferralTracking::Middleware.new(app))

    env = Rack::MockRequest.env_for('/')

    app.call(env)
  end

end
