module Bitly
  module V3
    # The client is the main part of this gem. You need to initialize the client with your
    # username and API key and then you will be able to use the client to perform
    # all the rest of the actions available through the API.
    class Client
      include HTTParty
      base_uri 'http://api.bit.ly/v3/'

      # Requires a login and api key. Get yours from your account page at http://bit.ly/a/account
      def initialize(login, api_key)
        @default_query_opts = { :login => login, :apiKey => api_key }
      end
    
      # Validates a login and api key
      def validate(x_login, x_api_key)
        response = get('/validate', :query => { :x_login => x_login, :x_apiKey => x_api_key })
        return response['data']['valid'] == 1
      end
      alias :valid? :validate
    
      # Checks whether a domain is a bitly.Pro domain
      def bitly_pro_domain(domain)
        response = get('/bitly_pro_domain', :query => { :domain => domain })
        return response['data']['bitly_pro_domain']
      end
      alias :pro? :bitly_pro_domain
    
      # Shortens a long url
      #
      # Options can be:
      #
      # [domain]                choose bit.ly or j.mp (bit.ly is default)
      #
      # [x_login and x_apiKey]  add this link to another user's history (both required)
      #
      def shorten(long_url, opts={})
        query = { :longUrl => long_url }.merge(opts)
        response = get('/shorten', :query => query)
        return Bitly::V3::Url.new(self, response['data'])
      end
    
      # Expands either a hash, short url or array of either.
      #
      # Returns the results in the order they were entered
      def expand(input)
        get_method(:expand, input)
      end
    
      # Expands either a hash, short url or array of either and gets click data too.
      #
      # Returns the results in the order they were entered
      def clicks(input)
        get_method(:clicks, input)
      end
        
      private
    
      def get(method, opts={})
        opts[:query] ||= {}
        opts[:query].merge!(@default_query_opts)
        response = self.class.get(method, opts)
        if response['status_code'] == 200
          return response
        else
          raise BitlyError.new(response['status_txt'], response['status_code'])
        end
      end
    
      def is_a_short_url?(input)
        input.match(/^http:\/\//)
      end
    
      def get_method(method, input)
        input = [input] if input.is_a? String
        query = []
        input.each do |i|
          if is_a_short_url?(i)
            query << "shortUrl=#{CGI.escape(i)}"
          else
            query << "hash=#{CGI.escape(i)}"
          end
        end
        query = "/#{method}?" + query.join('&')
        response = get(query)
        results = []
        response['data'][method.to_s].each do |url|
          if url['error'].nil?
            # builds the results array in the same order as the input
            results[input.index(url['short_url'] || url['hash'])] = Bitly::V3::Url.new(self, url)
            # remove the key from the original array, in case the same hash/url was entered twice
            input[input.index(url['short_url'] || url['hash'])] = nil
          else
            results[input.index(url['short_url'] || url['hash'])] = Bitly::V3::MissingUrl.new(url)
            input[input.index(url['short_url'] || url['hash'])] = nil
          end
        end
        return results.length > 1 ? results : results[0]
      end
    
    end
  end
end