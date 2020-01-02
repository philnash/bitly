# frozen_string_literal: true

require "net/http"

module Bitly
  module HTTP
    module Adapters
      class NetHTTP
        def request(request)
          Net::HTTP.start(request.uri.host, request.uri.port, use_ssl: true) do |http|
            method = Object.const_get("Net::HTTP::#{request.method.capitalize}")
            full_path = request.uri.path
            full_path += "?#{request.uri.query}" if request.uri.query
            http_request = method.new full_path
            http_request.body = request.body
            request.headers.each do |header, value|
              http_request[header] = value
            end
            response = http.request http_request
            success = response.kind_of? Net::HTTPSuccess
            return [response.code, response.body, response.to_hash, success]
          end
        end
      end
    end
  end
end