module Bitly
  module V3
    # OAuth consumer for authentication
    class OAuth
      attr_reader :access_token
      def initialize(consumer_token, consumer_secret)
        @consumer_token, @consumer_secret = consumer_token, consumer_secret
      end

      # Get the OAuth 2 client
      def client
        @client ||= ::OAuth2::Client.new(
          @consumer_token,
          @consumer_secret,
          :site => 'https://api-ssl.bit.ly',
          :token_url => '/oauth/access_token'
        )
      end

      # Get the url to redirect a user to, pass the url you want the user
      # to be redirected back to.
      def authorize_url(redirect_url)
        client.auth_code.authorize_url(:redirect_uri => redirect_url).gsub(/api-ssl\./,'')
      end

      # Get the access token. You must pass the exact same redirect_url passed
      # to the authorize_url method
      def get_access_token_from_code(code,redirect_url)
        @access_token ||= client.auth_code.get_token(code, :redirect_uri => redirect_url, :parse => :query)
      end

      # If you already have a user token, this method gets the access token
      def get_access_token_from_token(token, params={})
        params = params.inject({}) { |options, (key, value)| options[key.to_s] = value; options }
        @access_token ||= ::OAuth2::AccessToken.new(client, token, params)
      end
    end
  end
end