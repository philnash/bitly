module Bitly
  module V3
    # A user requires an oauth access token. The flow is as follows:
    #
    #     o = Bitly::V3::OAuth.new(consumer_token, consumer_secret)
    #     o.authorize_url(redirect_url)
    #     #=> "https://bit.ly/oauth/authorize?client_id=#{consumer_token}&type=web_server&redirect_uri=http%3A%2F%2Ftest.local%2Fbitly%2Fauth"
    # Redirect your users to this url, when they authorize your application
    # they will be redirected to the url you provided with a code parameter.
    # Use that parameter, and the exact same redirect url as follows:
    #
    #     o.get_access_token_from_code(params[:code], redirect_url)
    #     #=> #<OAuth2::AccessToken ...>
    #
    # Then use that access token to create your user object.
    #
    #    u=Bitly::V3::User.new(o.access_token)
    class User
      attr_accessor :login, :api_key
      
      def initialize(access_token)
        @access_token = access_token
        @login = access_token['login'] || access_token['username']
        @api_key = access_token['apiKey'] || access_token['api_key']
      end
    
      # OAuth 2 endpoint that provides a list of top referrers (up to 500 per
      # day) for a given user’s bit.ly links, and the number of clicks per referrer. 
      #
      # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/referrers
      def referrers(opts={})
        if @referrers.nil? || opts.delete(:force)
          @referrers = get_method(:referrers, Bitly::V3::Referrer, opts)
        end
        @referrers
      end
    
      # OAuth 2 endpoint that provides a list of countries from which clicks
      # on a given user’s bit.ly links are originating, and the number of clicks per country. 
      #
      # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/countries
      def countries(opts={})
        if @countries.nil? || opts.delete(:force)
          @countries = get_method(:countries, Bitly::V3::Country, opts)
        end
        @countries
      end
    
      # OAuth 2 endpoint that provides a given user’s 100 most popular links
      # based on click traffic in the past hour, and the number of clicks per link. 
      #
      # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/realtime_links
      def realtime_links(opts={})
        if @realtime_links.nil? || opts.delete(:force)
          result = Crack::JSON.parse(@access_token.get("/v3/user/realtime_links", opts))
          if result['status_code'] == 200
            @realtime_links = result['data']['realtime_links'].map { |rs| Bitly::V3::RealtimeLink.new(rs) }
          else
            raise BitlyError.new(results['status_txt'], results['status_code'])
          end
        end
        @realtime_links
      end
    
      # OAuth 2 endpoint that provides the total clicks per day on a user’s bit.ly links.
      #
      # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/clicks
      def clicks(opts={})
        get_clicks(opts)
        @clicks
      end
    
      # Displays the total clicks returned from the clicks method.
      def total_clicks(opts={})
        get_clicks(opts)
        @total_clicks
      end
      
      # Returns a Bitly Client using the credentials of the user.
      def client
        @client ||= Bitly::V3::Client.new(login, api_key)
      end
    
      private
    
      def get_method(method, klass, opts)
        result = Crack::JSON.parse(@access_token.get("/v3/user/#{method.to_s}", opts))
        if result['status_code'] == 200
          results = result['data'][method.to_s].map do |rs|
            rs.inject([]) do |results, obj|
              results << klass.new(obj)
            end
          end
          return results
        else
          raise BitlyError.new(results['status_txt'], results['status_code'])
        end
      end
    
      def get_clicks(opts={})
        if @clicks.nil? || opts.delete(:force)
          result = Crack::JSON.parse(@access_token.get("/v3/user/clicks", opts))
          if result['status_code'] == 200
            @clicks = result['data']['clicks'].map { |rs| Bitly::V3::Day.new(rs) }
            @total_clicks = result['data']['total_clicks']
          else
            raise BitlyError.new(results['status_txt'], results['status_code'])
          end
        end
      end
    end
  end
end