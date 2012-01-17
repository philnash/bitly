module Bitly
  module Strategy
    class OAuth < Base
      extend Forwardable
      delegate [ :run_request ] => :access_token

      BASE_URL =  'https://api-ssl.bit.ly/v3/'

      def initialize(consumer_token, consumer_secret)
        @consumer_token  = consumer_token
        @consumer_secret = consumer_secret
      end

      # Get the url to redirect a user to, pass the url you want the user
      # to be redirected back to.
      def authorize_url(redirect_url)
        client.auth_code.authorize_url(:redirect_uri => redirect_url)
      end

      # Get the access token. You must pass the exact same redirect_url passed
      # to the authorize_url method
      def get_access_token_from_code(code, redirect_url)
        access_token = client.auth_code.get_token(code, :redirect_uri => redirect_url, :parse => :query)
        Bitly::Strategy::AccessToken.new(access_token)
      end

      # If you already have a user token, this method gets the access token
      def get_access_token_from_token(token, params={})
        params.stringify_keys!
        access_token = ::OAuth2::AccessToken.new(client, token, params)
        Bitly::Strategy::AccessToken.new(access_token)
      end

      # If you already have a user token, this method sets the access token
      def set_access_token_from_token!(token, params={})
        @access_token ||= get_access_token_from_token(token, params)
      end

      private
      # Get the OAuth 2 client
      def client
        @client ||= ::OAuth2::Client.new(@consumer_token, @consumer_secret, :site => BASE_URL, :token_url => '/oauth/access_token')
      end

      def access_token
        @access_token
      end
    end
  end
end
