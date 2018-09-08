module Bitly
  module HTTP
    class Client
      def initialize(adapter=Bitly::HTTP::Adapters::NetHTTP.new)
        @adapter = adapter
      end

      ##
      # The main method for the HTTP client. It receives a Bitly::HTTP::Request
      # object, makes the request described and returns a Bitly::HTTP::Response.
      #
      # @param [Bitly::HTTP::Request] request The request that should be made
      #
      # @return [Bitly::HTTP::Response] The response from the request.
      #
      # @raise [Bitly::Error] If the response is not a successful response
      #   in the 2xx range, then we raise an error with the response passed as
      #   an argument. It is up to the application to catch this error.
      def request(request)
        status, body, headers, success = @adapter.request(request)
        response = Bitly::HTTP::Response.new(status: status, body: body, headers: headers)
        if success
          return response
        else
          raise Bitly::Error, response
        end
      end
    end
  end
end