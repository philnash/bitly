# frozen_string_literal: true

module Bitly
  module HTTP
    class Request
      # @return [URI] The full URI for the request
      attr_reader :uri

      # @return [String] The HTTP method that the request should be.
      attr_reader :method

      # @return [Hash] A hash of parameters that will be turned into query
      #   parameters or a request body
      attr_reader :params

      # @return [Hash] A hash of HTTP headers that will be included with the
      #   request
      attr_reader :headers

      ##
      # Creates a new Bitly::HTTP::Request object, which is to be used by the
      # [Bitly::HTTP::Client].
      #
      # @example
      #     response = Bitly::HTTP::Request.new(URI.parse('https://api-ssl.bitly.com/v3/shorten'))
      #
      # @param [URI] uri A [URI] that you want to make the request to.
      # @param [String] method The HTTP method that should be used to make the
      #   request.
      # @param [Hash] params The parameters to be sent as part of the request.
      #   GET parameters will be sent as part of the query string and other
      #   methods will be added to the request body.
      def initialize(uri: uri, method: method, params: {}, headers: {})
        errors = []
        @uri = uri
        errors << "uri must be an object of type URI. Received a #{uri.class}" unless uri.kind_of?(URI)
        @method = method
        errors << "method must be a valid HTTP method. Received: #{method}." unless HTTP_METHODS.include?(method)
        @params = params
        errors << "params must be a hash. Received: #{params.inspect}." unless params.kind_of?(Hash)
        @headers = headers
        errors << "headers must be a hash. Received: #{headers.inspect}." unless headers.kind_of?(Hash)
        raise ArgumentError, errors.join("\n") if errors.any?
      end

      private

      HTTP_METHODS = [
        "GET",
        "POST",
        "HEAD",
        "PUT",
        "PATCH",
        "DELETE",
        "CONNECT",
        "OPTIONS",
        "TRACE"
      ]
    end
  end
end