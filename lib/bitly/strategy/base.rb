module Bitly
  module Strategy
    class Base
      def request(*args)
        response = Bitly::Response.new(run_request(*args))
        if response.success?
          response.body
        else
          raise BitlyError.new(response)
        end
      end

      # Validates a login and api key
      def validate(x_login, x_api_key)
        response = request(:get, :validate, :x_login => x_login, :x_apiKey => x_api_key)
        return response['valid'] == 1
      end
      alias :valid? :validate

      private
      def run_request(*args)
        raise "Define this in the subclass"
      end
    end
  end
end
