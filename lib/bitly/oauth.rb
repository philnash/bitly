# frozen_string_literal: true
require "oauth2"

module Bitly
  ##
  # The Oauth class handles interacting with the Bitly API to setup OAuth flows
  # to redirect the user to authorize with Bitly and turn the resultant code
  # into an OAuth access token.
  class OAuth
    attr_reader :client_id, :client_secret

    ##
    # Creates a new Bitly::OAuth client to retrieve user access tokens.
    #
    # To initialize a Bitly::OAuth client you need a client_id and client_secret
    # which you will get when you register your application at
    # https://bitly.com/a/oauth_apps
    #
    # @example
    #     oauth = Bitly::OAuth.new(client_id: "test", client_secret: "secret")
    #
    # @param [String] client_id The client ID from
    #   https://bitly.com/a/oauth_apps
    # @param [String] client_secret The client_secret from
    #   https://bitly.com/a/oauth_apps
    # @return [Bitly::OAuth] An authenticated Bitly::OAuth instance
    # @since 2.0.0
    def initialize(client_id:, client_secret:)
      @client_id = client_id
      @client_secret = client_secret
      @client = OAuth2::Client.new(
        client_id,
        client_secret,
        :site => 'https://api-ssl.bitly.com',
        :token_url => '/oauth/access_token',
      )
    end

    ##
    # Returns the URL that you need to redirect the user to, so they can give
    # your app permission to use their Bitly account.
    #
    # @example
    #     oauth.authorize_uri("https://example.com/oauth/redirect")
    #     # => "https://bitly.com/oauth/authorize?client_id=...&redirect_uri=https://example.com/oauth_page"
    #
    # @param [String] redirect_uri The URI you want Bitly to redirect the user
    #   back to once they are authorized. This should match the redirect_uri
    #   you set in your Bitly OAuth app.
    # @param [String] state An optional state that you can pass to the
    #   authorize URI that will be returned in the redirect.
    #
    # @return [String] The authorize URI that you should use to redirect your
    #   user.
    # @since 2.0.0
    def authorize_uri(redirect_uri, state: nil)
      params = {
        redirect_uri: redirect_uri,
        client_id: client_id
      }
      params[:state] = state if state
      @client.authorize_url(**params).gsub(/api-ssl\./,'')
    end

    ##
    # When the user is redirected to your redirect URI, Bitly will include a
    # code parameter. You then use the original redirect URI and the code to
    # retrieve an access token.
    #
    # @example
    #     oauth.access_token(redirect_uri: "https://example.com/oauth/redirect", "code")
    #     # => "9646c4f76e32c18f0afad3b3ed9524f3c917775b"
    def access_token(redirect_uri:, code:)
      begin
        @access_token ||= @client.get_token(
          redirect_uri: redirect_uri,
          code: code
        ).token
      rescue OAuth2::Error => e
        raise Bitly::Error, e.response.parsed
      end
    end
  end
end