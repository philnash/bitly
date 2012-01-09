module Bitly
  module Strategy
    class ApiKey < Base
      include HTTParty
      base_uri 'http://api.bit.ly/v3/'
      query_string_normalizer proc { |query|
        query.map do |key, value|
          case value
          when Array
            value.map { |v| "#{key}=#{CGI.escape( v.to_s )}" }
          else
            "#{key}=#{CGI.escape( value.to_s )}"
          end
        end.compact.join('&')
      }

      def initialize(login, api_key)
        @login   = login
        @api_key = api_key
      end

      private
      # Make a request using the login and apiKey
      def run_request(verb, method, options={})
        self.class.send(verb, "/#{method}", :query => authorization_params.merge(options))
      end

      def authorization_params
        { :login => @login, :apiKey => @api_key }
      end
    end
  end
end
