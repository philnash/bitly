module Bitly
  module V3
    # A link requires an oauth access token. The flow is as follows:
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
    #    l=Bitly::V3::Link.new(o.access_token)
    class Link
      include HTTParty
      base_uri 'https://api-ssl.bit.ly/v3/'
      attr_accessor :login, :api_key

      def initialize(access_token)
        @access_token = access_token
        @login = access_token['login'] || access_token['username']
        @api_key = access_token['apiKey'] || access_token['api_key']
      end
      
      # OAuth 2 endpoint that provides the total clicks for a link.
      #
      # http://dev.bitly.com/link_metrics.html
      def clicks(link, opts={})
        opts.merge!(:access_token => @access_token.token, :link => link)
        result = self.class.get("/link/clicks", :query => opts)
        if result['status_code'] == 200
          if opts[:rollup].nil? || opts[:rollup]
            # Have total clicks so just return total
            result['data']['link_clicks']
          else
            # Have an array of reults so process
            result['data']['link_clicks'].map { |lc| {:time => Time.at(lc['dt']), :clicks => lc['clicks']}}
          end
        else
          raise BitlyError.new(result['status_txt'], result['status_code'])
        end
        
      end
      
    end
  end
end