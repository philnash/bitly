# frozen_string_literal: true

require "net/http"

module Bitly
  module HTTP
    module Adapters
      class NetHTTP
        DEFAULT_OPTS = { use_ssl: true }

        def initialize(proxy_addr: nil, proxy_port: nil, proxy_user: nil, proxy_pass: nil, request_opts: {})
          @request_opts = DEFAULT_OPTS.merge(request_opts)
          @proxy_addr = proxy_addr
          @proxy_port = proxy_port
          @proxy_user = proxy_user
          @proxy_pass = proxy_pass
        end

        def request(request)
          Net::HTTP.start(request.uri.host, request.uri.port, @proxy_addr, @proxy_port, @proxy_user, @proxy_pass, @request_opts) do |http|
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