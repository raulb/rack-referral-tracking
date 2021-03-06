require 'cgi'
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

        params        = CGI.parse env['QUERY_STRING']
        host          = Domainatrix.parse(env["SERVER_NAME"]).domain_with_tld
        cookie_domain = '.' + host

        if referred_from_outside?(env)
          if ENV.has_key?('REFERRAL_SECRET')
            referer = Fernet.generate(ENV['REFERRAL_SECRET']) do |generator|
              generator.data = { :referrer => env["HTTP_REFERER"] }
            end
          else
            referer = nil
          end
        end

        Rack::Utils.set_cookie_header!(headers, "utm_campaign", :value => params['utm_campaign'], :domain => cookie_domain, :path => '/', :httponly => true, :secure => true) if params.has_key? 'utm_campaign'
        Rack::Utils.set_cookie_header!(headers, "utm_source", :value => params['utm_source'], :domain => cookie_domain, :path => '/', :httponly => true, :secure => true) if params.has_key? 'utm_source'
        Rack::Utils.set_cookie_header!(headers, "utm_medium", :value => params['utm_medium'], :domain => cookie_domain, :path => '/', :httponly => true, :secure => true) if params.has_key? 'utm_medium'
        Rack::Utils.set_cookie_header!(headers, "ref", :value => referer, :domain => cookie_domain, :path => '/', :httponly => true, :secure => true) if referer
        body.close if body.respond_to?(:close)
        [status, headers, body]
      end

      private

      def referred_from_outside?(env)
        if env.has_key? 'HTTP_REFERER'
          referer_domain = Domainatrix.parse(env['HTTP_REFERER']).domain_with_tld
          host           = Domainatrix.parse(env["HTTP_HOST"]).domain_with_tld
          host != referer_domain
        end
      end

    end
  end
end
