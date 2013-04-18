require 'fernet'
require 'uri'

module Rack
  module ReferralTracking
    class Middleware

      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)

        params = CGI.parse env['QUERY_STRING']

        if referred_from_outside?(env)
          referer = Fernet.generate(ENV['SECRET']) do |generator|
            generator.data = { :referrer => env["HTTP_REFERER"] }
          end
        end

        cookies[:utm_campaign] = { :value => params[:utm_campaign], :expires => COOKIE_EXPIRES,:domain => uri.host } if params[:utm_campaign].present?
        cookies[:utm_source] = { :value => params[:utm_source], :expires => COOKIE_EXPIRES,:domain => uri.host } if params[:utm_source].present?
        cookies[:utm_medium] = { :value => params[:utm_medium], :expires => COOKIE_EXPIRES,:domain => uri.host } if params[:utm_medium].present?
        cookies[:ref] = {:value => referer, :expires => COOKIE_EXPIRES,:domain => uri.host }

      end

      private

      def referred_from_outside?(env)
        env.has_key? 'HTTP_REFERER'
      end

    end
  end
end
