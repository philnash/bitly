# frozen_string_literal: true

module Bitly
  module API
    ##
    # The class that all the API requests are made through. The
    # Bitly::API::Client is authorized with an OAuth token and takes care of
    # setting the correct path, parameters and headers when making requests to
    # the API.
    #
    # This class will be used the most and includes short cut methods to request
    # the popular objects in the system.
    class Client
      USER_AGENT = "Ruby Bitly/#{Bitly::VERSION}"

      ##
      # Creates a new Bitly::API::Client, authorized with an OAuth token and
      # with an optional HTTP client.
      #
      # @example
      #     client = Bitly::API::Client.new(token: oauth_token)
      #
      # @param http [Bitly::HTTP::Client] An HTTP client, you can pass your own
      #     if you have a custom client you would like to use.
      # @param token [String] An OAuth token for a user authorized with the API.
      #
      # @return [Bitly::API::Client]
      def initialize(http: Bitly::HTTP::Client.new, token:)
        @http = http
        @token = token
      end

      ##
      # Makes a request to the API by building up a Bitly::HTTP::Request and
      # using the HTTP client to make that request and return a
      # Bitly::HTTP::Response.
      #
      # @example
      #     client.request("/shorten", method: "POST", params: { long_url => "https://example.com" })
      #
      # @param path [String] The resource path
      # @param method [String] The HTTP method to use to request the path
      # @param params [Hash<String, String>] The parameters to pass to the API
      # @param headers [Hash<String, String>] Custom headers for the request
      #
      # @return [Bitly::HTTP::Response]
      def request(path:, method: 'GET', params: {}, headers: {})
        params = params.select { |k,v| !v.nil? }
        headers = default_headers.merge(headers)
        uri = Bitly::API::BASE_URL.dup
        uri.path += path
        request = Bitly::HTTP::Request.new(uri: uri, method: method, params: params, headers: headers)
        @http.request(request)
      end

      ##
      # Shortens a long URL
      #
      # @example
      #     client.shorten(long_url: "http://example.com")
      #
      # @param long_url [String] The URL you want to shorten
      # @param domain [String] The domain you want to shorten the URL with.
      #     "bit.ly" by default.
      # @param group_guid [String] The group you want shorten this URL under
      #
      # @return [Bitly::API::Bitlink]
      def shorten(long_url:, domain: nil, group_guid: nil)
        Bitlink.shorten(client: self, long_url: long_url, domain: domain, group_guid: group_guid)
      end

      ##
      # Lists organizations the authorized user can see.
      #
      # @example
      #     organizations = client.organizations
      #
      # @return [Bitly::API::Organization::List]
      def organizations
        Organization.list(client: self)
      end

      ##
      # Fetch a particular organization.
      #
      # @example
      #     organization = client.organization(guid)
      #
      # @param guid [String] The guid of the organization you want.
      #
      # @return [Bitly::API::Organization]
      def organization(guid)
        Organization.fetch(client: self, guid: guid)
      end

      ##
      # Fetch the shorten counts for an organization.
      #
      # @example
      #     shorten_counts = client.organization_shorten_counts(guid: org_guid)
      #
      # @param guid [String] The guid of the organization for which you want the
      #      shorten counts.
      #
      # @return [Bitly::API::ShortenCounts]
      def organization_shorten_counts(guid:)
        Bitly::API::ShortenCounts.by_organization(client: self, guid: guid)
      end

      ##
      # Lists groups the authorized user can see.
      #
      # @example
      #     groups = client.groups
      #
      # @param organization [String] The organization guid of the organization
      #     for which you want the available groups.
      #
      # @return [Bitly::API::Group::List]
      def groups(organization: nil)
        Group.list(client: self, organization: organization)
      end

      ##
      # Fetch a particular group.
      #
      # @example
      #     group = client.group(guid)
      #
      # @param guid [String] The guid of the group you want.
      #
      # @return [Bitly::API::Group]
      def group(guid)
        Group.fetch(client: self, guid: guid)
      end

      ##
      # Fetch the shorten counts for a group.
      #
      # @example
      #     shorten_counts = client.group_shorten_counts(guid: group_guid)
      #
      # @param guid [String] The guid of the group for which you want the
      #      shorten counts.
      #
      # @return [Bitly::API::ShortenCounts]
      def group_shorten_counts(guid:)
        Bitly::API::ShortenCounts.by_group(client: self, guid: guid)
      end

      ##
      # Fetch Branded Short Domains (BSDs).
      #
      # @example
      #     bsds = client.bsds
      #
      # @return [Array<String>]
      def bsds
        BSD.list(client: self)
      end

      private

      def default_headers
        {
          "User-Agent" => USER_AGENT,
          "Authorization" => "Bearer #{@token}",
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }
      end
    end
  end
end