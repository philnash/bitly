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
      #     if you have a custom client you would like to use. Custom clients
      #     must have a request method that takes a Bitly::HTTP::Request object
      #     as a single parameter and returns a Bitly::HTTP::Response object (or
      #     an object that behaves like one).
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
      # Shortens a long URL.
      # [`POST /v4/shorten`](https://dev.bitly.com/v4/#operation/createBitlink)
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
      # Creates a Bitlink with more options than #shorten.
      # [`POST /v4/bitlinks`](https://dev.bitly.com/v4/#operation/createFullBitlink)
      #
      # @example
      #     bitlink = client.create_bitlink(long_url: "http://example.com", title: "An example")
      #
      # @param long_url [String] A long URL that you want shortened
      # @param domain [String] The bitly domain you want to shorten, API default
      #     is "bit.ly"
      # @param group_guid [String] The GUID of the group for which you want to
      #     shorten this URL
      # @param title [String] A descriptive title for the link
      # @param tags [Array<String>] Some tags for the Bitlink
      # @param deeplinks [Array<Bitly::API::Bitlink::Deeplink>]
      #
      # @return [Bitly::API::Bitlink]
      def create_bitlink(long_url:, domain: nil, group_guid: nil, title: nil, tags: nil, deeplinks: nil)
        Bitlink.create(client: self, long_url: long_url, domain: domain, group_guid: group_guid, title: title, tags: tags, deeplinks: deeplinks)
      end

      ##
      # Return information about a bitlink
      # [`GET /v4/bitlink/{bitlink}`](https://dev.bitly.com/v4/#operation/getBitlink)
      #
      # @example
      #     bitlink = client.bitlink(bitlink: "bit.ly/example")
      #
      # @param bitlink [String] The bitlink you want information about
      #
      # @return [Bitly::API::Bitlink]
      def bitlink(bitlink:)
        Bitlink.fetch(client: self, bitlink: bitlink)
      end

      ##
      # Return public information about a bitlink.
      # [`POST /v4/expand`](https://dev.bitly.com/v4/#operation/expandBitlink)
      #
      # @example
      #     bitlink = client.expand(bitlink: "bit.ly/example")
      #
      # @param bitlink [String] The bitlink you want information about
      #
      # @return [Bitly::API::Bitlink]
      def expand(bitlink:)
        Bitlink.expand(client: self, bitlink: bitlink)
      end

      ##
      # Returns a list of Bitlinks sorted by clicks.
      # [`GET /v4/groups/{group_guid}/bitlinks/{sort}`](https://dev.bitly.com/v4/#operation/getSortedBitlinks)
      #
      # The API returns a separate list of the links and the click counts, but
      # this method assigns the number of clicks for each link to the Bitlink
      # object and sorts the resulting list in descending order.
      #
      # Sorted lists are not paginated, so do not have any pagination detail.
      #
      # @example
      #     links = client.sorted_list(group_guid: guid)
      #
      # @param group_guid [String] The group for which you want to return links
      # @param sort [String] The data to sort on. Default and only option is
      #     "clicks".
      # @param unit [String] A unit of time. Default is "day" and can be
      #     "minute", "hour", "day", "week" or "month"
      # @param units [Integer] An integer representing the time units to query
      #     data for. pass -1 to return all units of time. Defaults to -1.
      # @param unit_reference [String] An ISO-8601 timestamp, indicating the
      #     most recent time for which to pull metrics. Will default to current
      #     time.
      # @param size [Integer] The number of links to be returned. Defaults to 50
      #
      # @returns [Bitly::API::Bitlink::List]
      def sorted_bitlinks(
        group_guid:,
        sort: "clicks",
        unit: nil,
        units: nil,
        unit_reference: nil,
        size: nil
      )
        Bitlink.sorted_list(
          client: self,
          group_guid: group_guid,
          sort: sort,
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      ##
      # Update a Bitlink.
      # [`PATCH /v4/bitlink/{bitlink}`](https://dev.bitly.com/v4/#operation/updateBitlink)
      #
      # The parameters listed below are from the documentation. Some only work
      # if you have a Bitly Pro account.
      #
      # @example
      #     client.update_bitlink(bitlink: bitlink, title: "New title")
      #
      # @param archived [Boolean]
      # @param tags [Array<String>]
      # @param created_at [String]
      # @param title [String]
      # @param deeplinks [Array<Bitly::API::Bitlink::Deeplink>]
      # @param created_by [String]
      # @param long_url [String]
      # @param client_id [String]
      # @param custom_bitlinks [Array<String>]
      # @param link [String]
      # @param id [String]
      # @param references [Hash<String, String>]
      #
      # @returns [Bitly::API::Bitlink]
      def update_bitlink(
        bitlink:,
        archived: nil,
        tags: nil,
        created_at: nil,
        title: nil,
        deeplinks: nil,
        created_by: nil,
        long_url: nil,
        client_id: nil,
        custom_bitlinks: nil,
        link: nil,
        id: nil,
        references: nil
      )
        bitlink = Bitlink.new(data: { "id" => bitlink }, client: self)
        bitlink.update(
          archived: archived,
          tags: tags,
          created_at: created_at,
          title: title,
          deeplinks: deeplinks,
          created_by: created_by,
          long_url: long_url,
          client_id: client_id,
          custom_bitlinks: custom_bitlinks,
          link: link,
          id: id,
          references: references
        )
      end

      ##
      # Get the clicks for a bitlink.
      # [`GET /v4/bitlink/{bitlink}/clicks`](https://dev.bitly.com/v4/#operation/getClicksForBitlink)
      #
      # @param bitlink [String] The Bitlink for which you want the clicks
      # @param sort [String] The data to sort on. Default and only option is
      #     "clicks".
      # @param unit [String] A unit of time. Default is "day" and can be
      #     "minute", "hour", "day", "week" or "month"
      # @param units [Integer] An integer representing the time units to query
      #     data for. pass -1 to return all units of time. Defaults to -1.
      # @param unit_reference [String] An ISO-8601 timestamp, indicating the
      #     most recent time for which to pull metrics. Will default to current
      #     time.
      # @param size [Integer] The number of links to be returned. Defaults to 50
      #
      # @return [Bitly::API::Bitlink::LinkClick::List]
      def bitlink_clicks(bitlink:, unit: nil, units: nil, unit_reference: nil, size: nil)
        Bitlink::LinkClick.list(
          client: self,
          bitlink: bitlink,
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      ##
      # Get a list of organizations from the API.
      # [`GET /v4/organizations`](https://dev.bitly.com/v4/#operation/getOrganizations)
      #
      # @example
      #     organizations = client.organizations
      #
      # @return [Bitly::API::Organization::List]
      def organizations
        Organization.list(client: self)
      end

      ##
      # Retrieve an organization from the API.
      # [`GET /v4/organizations/{organization_guid}`](https://dev.bitly.com/v4/#operation/getOrganization)
      #
      # @example
      #     organization = client.organization(organization_guid: guid)
      #
      # @param organization_guid [String] An organization guid
      #
      # @return [Bitly::API::Organization]
      def organization(organization_guid:)
        Organization.fetch(client: self, organization_guid: organization_guid)
      end

      ##
      # Shorten counts by organization
      # [`GET /v4/organizations/{organization_guid}/shorten_counts`](https://dev.bitly.com/v4/#operation/getOrganizationShortenCounts)
      #
      # @example
      #     shorten_counts = client.organization_shorten_counts(organization_guid: organization_guid)
      #
      # @param organization_guid [String] The guid of the organization for which
      #      you want shorten counts
      #
      # @return [Bitly::API::ShortenCounts]
      def organization_shorten_counts(organization_guid:)
        Bitly::API::ShortenCounts.by_organization(client: self, organization_guid: organization_guid)
      end

      ##
      # Gets the authorized user from the API.
      # [`GET /v4/user`](https://dev.bitly.com/v4/#operation/getUser)
      #
      # @example
      #     user = client.user
      #
      # @return [Bitly::API::User]
      def user
        User.fetch(client: self)
      end

      ##
      # Allows you to update the authorized user's name or default group guid.
      # [`PATCH /v4/user`](https://dev.bitly.com/v4/#operation/updateUser)]
      #
      # @example
      #     client.update_user(name: "New Name", default_group_guid: "aaabbb")
      #
      # @param name [String] A new name
      # @param default_group_guid [String] A new default guid
      #
      # @return [Bitly::API::User]
      def update_user(name: nil, default_group_guid: nil)
        user = Bitly::API::User.new(client: self, data: {})
        user.update(name: name, default_group_guid: default_group_guid)
      end

      ##
      # Lists groups the authorized user can see.
      # [`GET /v4/groups`](https://dev.bitly.com/v4/#operation/getGroups)
      #
      # @example
      #     groups = client.groups
      #
      # @param organization [String] The organization guid of the organization
      #     for which you want the available groups.
      #
      # @return [Bitly::API::Group::List]
      def groups(organization_guid: nil)
        Group.list(client: self, organization_guid: organization_guid)
      end

      ##
      # Fetch a particular group.
      # [`GET /v4/groups/{group_guid}`](https://dev.bitly.com/v4/#operation/getGroup)
      #
      # @example
      #     group = client.group(guid)
      #
      # @param guid [String] The guid of the group you want.
      #
      # @return [Bitly::API::Group]
      def group(group_guid:)
        Group.fetch(client: self, group_guid: group_guid)
      end

      ##
      # Fetch the shorten counts for a group.
      # [`GET /v4/groups/{group_guid}/shorten_counts`](https://dev.bitly.com/v4/#operation/getGroupShortenCounts)
      #
      # @example
      #     shorten_counts = client.group_shorten_counts(guid: group_guid)
      #
      # @param guid [String] The guid of the group for which you want the
      #      shorten counts.
      #
      # @return [Bitly::API::ShortenCounts]
      def group_shorten_counts(group_guid:)
        Bitly::API::ShortenCounts.by_group(client: self, group_guid: group_guid)
      end

      ##
      # Fetch a group's preferences.
      # [`GET /v4/groups/{group_guid}/preferences`](https://dev.bitly.com/v4/#operation/getGroupPreferences)
      #
      # @param group_guid [String] The group's guid
      #
      # @return [Bitly::API::Group::Preferences]
      def group_preferences(group_guid:)
        Group::Preferences.fetch(client: self, group_guid: group_guid)
      end

      ##
      # Update a group's preferences.
      # [`PATCH /v4/groups/{group_guid}/preferences`](https://dev.bitly.com/v4/#operation/updateGroupPreferences)
      #
      # @param group_guid [String] The group's guid
      # @param domain_preference [String] The new domain preference for this
      #     group
      #
      # @return [Bitly::API::Group::Preferences]
      def update_group_preferences(group_guid:, domain_preference:)
        group_preferences = Group::Preferences.new(data: { "group_guid" => group_guid }, client: self)
        group_preferences.update(domain_preference: domain_preference)
      end

      ##
      # Allows you to update a group's name, organization or BSDs.
      # [`PATCH /v4/groups/{group_guid}`](https://dev.bitly.com/v4/#operation/updateGroup)
      #
      # @example
      #     client.update_group(group_guid: group_guid, name: "New Name", organization_guid: "aaabbb")
      #
      # @param group_guid [String] The group's guid
      # @param name [String] A new name
      # @param organization_guid [String] A new organization guid
      # @param bsds [Array<String>] An array of branded short domains
      #
      # @return [Bitly::API::Group]
      def update_group(group_guid:, name: nil, organization_guid: nil, bsds: nil)
        group = Group.new(data: { "guid" => group_guid }, client: self)
        group.update(
          name: name,
          organization_guid: organization_guid,
          bsds: bsds
        )
      end

      ##
      # Retrieve a list of bitlinks by group
      # [`GET /v4/groups/{group_guid}/bitlinks`](https://dev.bitly.com/v4/#operation/getBitlinksByGroup)
      #
      # @example
      #     bitlinks = client.group_bitlinks(group_guid: guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param group_guid [String] The group guid for which you want bitlinks
      # @param size [Integer] The number of Bitlinks to return, max 100
      # @param page [Integer] The page of bitlinks to request
      # @param keyword [String] Custom keyword to filter on history entries
      # @param query [String] A value to search for Bitlinks
      # @param created_before [Integer] Timestamp as an integer unix epoch
      # @param created_after [Integer] Timestamp as an integer unix epoch
      # @param modified_after [Integer] Timestamp as an integer unix epoch
      # @param archived [String] Whether or not to include archived Bitlinks.
      #     One of "on", "off" or "both". Defaults to "off".
      # @param deeplinks [String] Filter to only Bitlinks that contain
      #     deeplinks. One of "on", "off" or "both". Defaults to "both".
      # @param domain_deeplinks [String] Filter to only Bitlinks that contain
      #     deeplinks configured with a custom domain. One of "on", "off" or
      #     "both". Defaults to "both".
      # @param campaign_guid [String] Filter to return only links for the given
      #     campaign GUID, can be provided
      # @param channel_guid [String] Filter to return only links for the given
      #     channel GUID, can be provided, overrides all other parameters
      # @param custom_bitlink [String] Filter to return only custom Bitlinks.
      #     One of "on", "off" or "both". Defaults to "both".
      # @param tags [Array<String>] Filter by the given tags.
      # @param encoding_login [Array<String>] Filter by the login of the
      #     authenticated user that created the Bitlink.
      #
      # @return [Bitly::API::Bitlink::PaginatedList]
      def group_bitlinks(
        group_guid:,
        size: nil,
        page: nil,
        keyword: nil,
        query: nil,
        created_before: nil,
        created_after: nil,
        modified_after: nil,
        archived: nil,
        deeplinks: nil,
        domain_deeplinks: nil,
        campaign_guid: nil,
        channel_guid: nil,
        custom_bitlink: nil,
        tags: nil,
        encoding_login: nil
      )
        Bitlink.list(
          client: self,
          group_guid: group_guid,
          size: size,
          page: page,
          keyword: keyword,
          query: query,
          created_before: created_before,
          created_after: created_after,
          modified_after: modified_after,
          archived: archived,
          deeplinks: deeplinks,
          domain_deeplinks: domain_deeplinks,
          campaign_guid: campaign_guid,
          channel_guid: channel_guid,
          custom_bitlink: custom_bitlink,
          tags: tags,
          encoding_login: encoding_login
        )
      end

      ##
      # Deletes a group.
      # [`DELETE /v4/groups/{group_guid}`](https://dev.bitly.com/v4/#operation/deleteGroup)
      #
      # @example
      #     client.delete_group(group_guid: group_guid)
      #
      # @return [Nil]
      def delete_group(group_guid:)
        group = Group.new(data: { "guid" => group_guid }, client: self)
        group.delete
      end

      ##
      # Gets the referring networks for the group.
      # [`GET /v4/groups/{group_guid}/referring_networks`](https://dev.bitly.com/v4/#operation/GetGroupMetricsByReferringNetworks)
      #
      # @param group_guid [String] The guid of the group
      # @param unit [String] A unit of time. Default is "day" and can be
      #     "minute", "hour", "day", "week" or "month"
      # @param units [Integer] An integer representing the time units to query
      #     data for. pass -1 to return all units of time. Defaults to -1.
      # @param unit_reference [String] An ISO-8601 timestamp, indicating the
      #     most recent time for which to pull metrics. Will default to current
      #     time.
      # @param size [Integer] The number of links to be returned. Defaults to 50
      #
      # @return [Bitly::API::ClickMetric::List]
      def group_referring_networks(group_guid:, unit: nil, units: nil, size: nil, unit_reference: nil)
        ClickMetric.list_referring_networks(
          client: self,
          group_guid: group_guid,
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      ##
      # Gets the country click metrics for the group.
      # [`GET /v4/groups/{group_guid}/countries`](https://dev.bitly.com/v4/#operation/getGroupMetricsByCountries)
      #
      # @param group_guid [String] The guid of the group
      # @param unit [String] A unit of time. Default is "day" and can be
      #     "minute", "hour", "day", "week" or "month"
      # @param units [Integer] An integer representing the time units to query
      #     data for. pass -1 to return all units of time. Defaults to -1.
      # @param unit_reference [String] An ISO-8601 timestamp, indicating the
      #     most recent time for which to pull metrics. Will default to current
      #     time.
      # @param size [Integer] The number of links to be returned. Defaults to 50
      #
      # @return [Bitly::API::ClickMetric::List]
      def group_countries(group_guid:, unit: nil, units: nil, size: nil, unit_reference: nil)
        ClickMetric.list_countries_by_group(
          client: self,
          group_guid: group_guid,
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      ##
      # Fetch Branded Short Domains (BSDs).
      # [`GET /v4/bsds`](https://dev.bitly.com/v4/#operation/getBSDs)
      #
      # @example
      #     bsds = client.bsds
      #
      # @return [Array<String>]
      def bsds
        BSD.list(client: self)
      end

      ##
      # Fetch OAuth application by client ID
      # [`GET /v4/apps/{client_id}`)](https://dev.bitly.com/v4/#operation/getOAuthApp)
      #
      # @example
      #     app = client.oauth_app(client_id: "client_id")
      #
      # @return Bitly::API::OAuthApp
      def oauth_app(client_id:)
        OAuthApp.fetch(client: self, client_id: client_id)
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