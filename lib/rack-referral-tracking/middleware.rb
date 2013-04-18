require 'domainatrix'
require 'fernet'
require 'uri'

module Rack
  module ReferralTracking
    class Middleware

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        params = CGI.parse env['QUERY_STRING']

        if referred_from_outside?(env)
          referer = Fernet.generate(ENV['SECRET']) do |generator|
            generator.data = { :referrer => env["HTTP_REFERER"] }
          end
        end

        Rack::Utils.set_cookie_header!(headers, "utm_campaign", :value => params['utm_campaign'], :domain => uri.host) if params['utm_campaign'].present?
        Rack::Utils.set_cookie_header!(headers, "utm_source", :value => params['utm_source'], :domain => uri.host) if params['utm_source'].present?
        Rack::Utils.set_cookie_header!(headers, "utm_medium", :value => params['utm_medium'], :domain => uri.host) if params['utm_medium'].present?
        Rack::Utils.set_cookie_header!(headers, "ref", :value => params['referer'], :domain => uri.host) if params['referer'].present?

        [status, headers, body]
      end

      private

      def referred_from_outside?(env)
        env.has_key? 'HTTP_REFERER'
      end

    end
  end
end
