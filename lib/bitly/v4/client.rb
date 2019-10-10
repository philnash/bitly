module Bitly
  module V4
    class Client
      include HTTParty
      base_uri 'https://api-ssl.bitly.com/v4/'

      def initialize(access_token, timeout=nil)
        self.timeout = timeout
        @access_token = access_token
      end

      def shorten(long_url, opts={})
        query = {body: { long_url: long_url }.merge(opts).to_json}
        response = post('/shorten', query)
        return Bitly::V4::Url.new(self, response)
      end

      private

      def timeout=(timeout=nil)
        self.class.default_timeout(timeout) if timeout
      end

      def post(method, opts={})
        opts[:headers] ||= {}
        opts[:headers]["Authorization"] = "Bearer #{@access_token}"
        opts[:headers]["Content-Type"] = "application/json"

        begin
          response = self.class.post(method, opts)
        rescue Timeout::Error
          raise BitlyTimeout.new("Bitly didn't respond in time", "504")
        end

        if [200, 201].include? response.code
          return response
        else
          raise BitlyError.new(response["message"], response.code)
        end
      end
    end
  end
end
