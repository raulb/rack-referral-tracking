module Rack
  module ReferralTracking
    class Middleware

      def initialize(app)
        @app = app
      end

      def call(env)
        puts "HAI!\n"

        @app.call(env)
      end

    end
  end
end
