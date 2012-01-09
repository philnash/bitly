module Bitly
  module Strategy
    class AccessToken < Base
      extend Forwardable
      delegate [ :client, :[] ] => :access_token

      def initialize(access_token)
        @access_token = access_token
      end

      private
      # Make a request from the access token
      def run_request(verb, method, options={})
        access_token.send(verb, method, :params => authorization_params.merge(options), :parse => :json)
      end

      def access_token
        @access_token
      end

      def authorization_params
        { :access_token => access_token.token }
      end
    end
  end
end
