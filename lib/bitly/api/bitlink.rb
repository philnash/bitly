# frozen_string_literal: true
require_relative "./base"
require_relative "./list"

module Bitly
  module API
    ##
    # A Bitlink represents a shortened link within Bitly.
    class Bitlink
      autoload :PaginatedList, File.join(File.dirname(__FILE__), "bitlink/paginated_list.rb")
      autoload :Deeplink, File.join(File.dirname(__FILE__), "bitlink/deeplink.rb")
      autoload :ClicksSummary, File.join(File.dirname(__FILE__), "bitlink/clicks_summary.rb")
      autoload :LinkClick, File.join(File.dirname(__FILE__), "bitlink/link_click.rb")

      include Base

      class List < Bitly::API::List ; end

      ##
      # Shortens a long url.
      # [`POST /v4/shorten`](https://dev.bitly.com/v4/#operation/createBitlink)
      #
      # @example
      #     bitlink = Bitly::API::Bitlink.shorten(client: client, long_url: long_url)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param long_url [String] A long URL that you want shortened
      # @param domain [String] The bitly domain you want to shorten, API default
      #     is "bit.ly"
      # @param group_guid [String] The GUID of the group for which you want to
      #     shorten this URL
      #
      # @return [Bitly::API::Bitlink]
      def self.shorten(client:, long_url:, domain: nil, group_guid: nil)
        response = client.request(
          path: "/shorten",
          method: "POST",
          params: {
            "long_url" => long_url,
            "domain" => domain,
            "group_guid" => group_guid
          })
        new(data: response.body, client: client, response: response)
      end

      ##
      # Creates a new Bitlink from a long URL. Similar to #shorten but takes
      # more parameters.
      # [`POST /v4/bitlinks`](https://dev.bitly.com/v4/#operation/createFullBitlink)
      #
      # @example
      #     bitlink = Bitly::API::Bitlink.create(client: client, long_url: long_url)
      #
      # @param client [Bitly::API::Client] An authorized API client
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
      def self.create(client:, long_url:, domain: nil, group_guid: nil, title: nil, tags: nil, deeplinks: nil)
        response = client.request(
          path: "/bitlinks",
          method: "POST",
          params: {
            "long_url" => long_url,
            "domain" => domain,
            "group_guid" => group_guid,
            "title" => title,
            "tags" => tags,
            "deeplinks" => deeplinks
          }
        )
        new(data: response.body, client: client, response: response)
      end

      ##
      # Return information about a bitlink
      # [`GET /v4/bitlink/{bitlink}`](https://dev.bitly.com/v4/#operation/getBitlink)
      #
      # @example
      #     bitlink = Bitly::API::Bitlink.fetch(client: client, bitlink: "bit.ly/example")
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param bitlink [String] The bitlink you want information about
      #
      # @return [Bitly::API::Bitlink]
      def self.fetch(client:, bitlink:)
        response = client.request(path: "/bitlinks/#{bitlink}")
        new(data: response.body, client: client, response: response)
      end

      ##
      # Return public information about a bitlink
      # [`POST /v4/expand`](https://dev.bitly.com/v4/#operation/expandBitlink)
      #
      # @example
      #     bitlink = Bitly::API::Bitlink.expand(client: client, bitlink: "bit.ly/example")
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param bitlink [String] The bitlink you want information about
      #
      # @return [Bitly::API::Bitlink]
      def self.expand(client:, bitlink:)
        response = client.request(path: "/expand", method: "POST", params: { "bitlink_id" => bitlink })
        new(data: response.body, client: client, response: response)
      end

      ##
      # Retrieve a list of bitlinks by group
      # [`GET /v4/groups/{group_guid}/bitlinks`](https://dev.bitly.com/v4/#operation/getBitlinksByGroup)
      #
      # @example
      #     bitlinks = Bitly::API::Bitlink.list(client: client, group_guid: guid)
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
      def self.list(
        client:,
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
        params = {
          "size" => size,
          "page" => page,
          "keyword" => keyword,
          "query" => query,
          "created_before" => created_before,
          "created_after" => created_after,
          "modified_after" => modified_after,
          "archived" => archived,
          "deeplinks" => deeplinks,
          "domain_deeplinks" => domain_deeplinks,
          "campaign_guid" => campaign_guid,
          "channel_guid" => channel_guid,
          "custom_bitlink" => custom_bitlink,
          "tags" => tags,
          "encoding_login" => encoding_login
        }
        response = client.request(path: "/groups/#{group_guid}/bitlinks", params: params)
        bitlinks = response.body["links"].map do |link|
          new(data: link, client: client)
        end
        PaginatedList.new(items: bitlinks, response: response, client: client)
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
      #     links = Bitly::API::Bitlink.sorted_list(client: client, group_guid: guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
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
      def self.sorted_list(client:, group_guid:, sort: "clicks", unit: nil, units: nil, unit_reference: nil, size: nil)
        params = {
          "unit" => unit,
          "units" => units,
          "unit_reference" => unit_reference,
          "size" => size
        }
        response = client.request(path: "/groups/#{group_guid}/bitlinks/#{sort}", params: params)
        link_clicks = response.body["sorted_links"]
        bitlinks = response.body["links"].map do |link|
          clicks = link_clicks.find { |c| c["id"] == link["id"] }["clicks"]
          new(data: link, client: client, clicks: clicks)
        end.sort { |a, b| b.clicks <=> a.clicks }
        List.new(items: bitlinks, response: response)
      end

      def self.attributes
        [:archived, :tags, :title, :created_by, :long_url, :client_id, :custom_bitlinks, :link, :id]
      end
      def self.time_attributes
        [:created_at]
      end
      attr_reader(*(attributes + time_attributes))
      attr_reader :deeplinks, :clicks

      def initialize(data:, client:, response: nil, clicks: nil)
        assign_attributes(data)
        if data["deeplinks"]
          @deeplinks = data["deeplinks"].map { |data| Deeplink.new(data: data) }
        else
          @deeplinks = []
        end
        @clicks = clicks
        @client = client
        @response = response
      end

      ##
      # Update the Bitlink.
      # [`PATCH /v4/bitlink/{bitlink}`](https://dev.bitly.com/v4/#operation/updateBitlink)
      #
      # The parameters listed below are from the documentation. Some only work
      # if you have a Bitly Pro account.
      #
      # @example
      #     bitlink.update(title: "New title")
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
      def update(
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
        @response = @client.request(
          path: "/bitlinks/#{@id}",
          method: "PATCH",
          params: {
            "archived" => archived,
            "tags" => tags,
            "created_at" => created_at,
            "title" => title,
            "deeplinks" => deeplinks,
            "created_by" => created_by,
            "long_url" =>long_url ,
            "client_id" => client_id,
            "custom_bitlinks" => custom_bitlinks,
            "link" => link,
            "id" => id,
            "references" => references
          }
        )
        assign_attributes(@response.body)
        self
      end

      # [`GET /v4/bitlink/{bitlink}/clicks/summary`](https://dev.bitly.com/v4/#operation/getClicksSummaryForBitlink)
      #
      # @return [Bitly::API::Bitlink::ClicksSummary]
      def clicks_summary(unit: nil, units: nil, unit_reference: nil, size: nil)
        ClicksSummary.fetch(client: @client, bitlink: id, unit: unit, units: units, unit_reference: unit_reference, size: size)
      end

      ##
      # Get the clicks for the bitlink.
      # [`GET /v4/bitlink/{bitlink}/clicks`](https://dev.bitly.com/v4/#operation/getClicksForBitlink)
      #
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
      def link_clicks(unit: nil, units: nil, unit_reference: nil, size: nil)
        LinkClick.list(client: @client, bitlink: id, unit: unit, units: units, unit_reference: unit_reference, size: size)
      end
    end
  end
end