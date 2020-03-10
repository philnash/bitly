# frozen_string_literal: true
require "json"
require "uri"

module Bitly
  module HTTP
    class Request
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
      #     request = Bitly::HTTP::Request.new(uri: URI.parse('https://api-ssl.bitly.com/v3/shorten'), method: "GET")
      #
      # @param [URI] uri A [URI] that you want to make the request to.
      # @param [String] method The HTTP method that should be used to make the
      #   request.
      # @param [Hash] params The parameters to be sent as part of the request.
      #   GET parameters will be sent as part of the query string and other
      #   methods will be added to the request body.
      def initialize(uri: , method: "GET", params: {}, headers: {})
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

      ##
      # Returns the uri for the request. If the request is an HTTP method that
      # uses a body to send data, then the uri is the one that the request was
      # initialised with. If the request uses query parameters, then the
      # parameters are serialised and added to the uri's query.
      #
      # @example
      #     uri = URI.parse("https://api-ssl.bitly.com/v3/shorten")
      #     request = Bitly::HTTP::Request.new(uri: uri, params: { foo: "bar" })
      #     request.uri.to_s
      #     # => "https://api-ssl.bitly.com/v3/shorten?foo=bar"
      #
      # @return [URI] The full URI for the request
      def uri
        uri = @uri.dup
        return uri if HTTP_METHODS_WITH_BODY.include?(@method)
        if uri.query
          existing_query = URI.decode_www_form(uri.query)
          new_query = hash_to_arrays(@params)
          uri.query = URI.encode_www_form((existing_query + new_query).uniq)
        else
          uri.query = URI.encode_www_form(@params) if @params.any?
        end
        uri
      end

      ##
      # Returns the body of the request if the request is an HTTP method that
      # uses a body to send data. The body is a JSON string of the parameters.
      # If the request doesn't use a body to send data, this returns nil.
      #
      # @example
      #     uri = URI.parse("https://api-ssl.bitly.com/v3/shorten")
      #     request = Bitly::HTTP::Request.new(uri: uri, method: 'POST', params: { foo: "bar" })
      #     request.body
      #     # => "{\"foo\":\"bar\"}"
      #
      # @return [String] The request body
      def body
        return nil if HTTP_METHODS_WITHOUT_BODY.include?(@method)
        return JSON.generate(params)
      end

      private

      def hash_to_arrays(hash)
        hash.map do |key, value|
          if value.is_a?(Array)
            value.map { |v| [key, v] }
          else
            [[key, value]]
          end
        end.flatten(1)
      end

      HTTP_METHODS_WITHOUT_BODY = [
        "GET",
        "HEAD",
        "DELETE",
        "TRACE",
        "OPTIONS"
      ]

      HTTP_METHODS_WITH_BODY = [
        "POST",
        "PUT",
        "PATCH",
        "CONNECT"
      ]

      HTTP_METHODS = HTTP_METHODS_WITH_BODY + HTTP_METHODS_WITHOUT_BODY
    end
  end
end