# frozen_string_literal: true

module Bitly
  module HTTP
    class Request
      # @return [URI] The full URI for the request
      attr_reader :uri

      # @return [String] The HTTP method that the request should be.
      attr_reader :method

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
      def initialize(uri: uri, method: method)
        errors = []
        @uri = uri
        errors << "uri must be an object of type URI" unless uri.kind_of?(URI)
        @method = method
        errors << "method must be a valid HTTP method. Received: #{method}." unless HTTP_METHODS.include?(method)
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