require "net/http"

module Bitly
  module HTTP
    module Adapters
      class NetHTTP
        def request(request)
          Net::HTTP.start(request.uri.host, request.uri.port, use_ssl: true) do |http|
            method = Object.const_get("Net::HTTP::#{request.method.capitalize}")
            request = method.new request.uri
            response = http.request request
            success = response.kind_of? Net::HTTPSuccess
            return [response.code, response.body, response.to_hash, success]
          end
        end
      end
    end
  end
end