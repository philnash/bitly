# frozen_string_literal: true
require_relative "./base"
require_relative "./list"
require_relative "./bitlink/deeplink"

module Bitly
  module API
    class Bitlink
      include Base

      class List < Bitly::API::List
        attr_reader :next_url, :prev_url, :size, :page, :total

        def initialize(items:, response: , client:)
          super(items: items, response: response)
          @client = client
          pagination = response.body["pagination"]
          @next_url = pagination["next"]
          @prev_url = pagination["prev"]
          @size = pagination["size"]
          @page = pagination["page"]
          @total = pagination["total"]
        end

        def has_next_page?
          !next_url.nil? && !next_url.empty?
        end

        def has_prev_page?
          !prev_url.nil? && !prev_url.empty?
        end

        def next_page
          has_next_page? ? get_page(uri: URI(next_url)) : nil
        end

        def prev_page
          has_prev_page? ? get_page(uri: URI(prev_url)) : nil
        end

        private

        def get_page(uri:)
          response = @client.request(path: uri.path.gsub(/\/v4/, ""), params: CGI.parse(uri.query))
          bitlinks = response.body["links"].map do |link|
            Bitlink.new(data: link, client: @client)
          end
          List.new(items: bitlinks, response: response, client: @client)
        end
      end

      def self.shorten(client:, long_url:, domain: nil, group_guid: nil)
        response = client.request(path: "/shorten", method: "POST", params: { "long_url" => long_url, "domain" => domain, "group_guid" => group_guid })
        new(data: response.body, client: client, response: response)
      end

      def self.create(client:, long_url:, domain: nil, group_guid: nil, title: nil, tags: nil, deeplinks: nil)
        response = client.request(path: "/bitlinks", method: "POST", params: {
          "long_url" => long_url,
          "domain" => domain,
          "group_guid" => group_guid,
          "title" => title,
          "tags" => tags,
          "deeplinks" => deeplinks
        })
        new(data: response.body, client: client, response: response)
      end

      def self.fetch(client:, bitlink:)
        response = client.request(path: "/bitlinks/#{bitlink}")
        new(data: response.body, client: client, response: response)
      end

      def self.expand(client:, bitlink:)
        response = client.request(path: "/expand", method: "POST", params: { "bitlink_id" => bitlink })
        new(data: response.body, client: client, response: response)
      end

      ##
      # Retrieve a list of bitlinks by group
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
      # @return [Bitly::API::Bitlink::List]
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
        List.new(items: bitlinks, response: response, client: client)
      end

      def self.attributes
        [:archived, :tags, :title, :created_by, :long_url, :client_id, :custom_bitlinks, :link, :id]
      end
      def self.time_attributes
        [:created_at]
      end
      attr_reader(*(attributes + time_attributes))
      attr_reader :deeplinks

      def initialize(data:, client:, response: nil)
        assign_attributes(data)
        if data["deeplinks"]
          @deeplinks = data["deeplinks"].map { |data| Deeplink.new(data: data) }
        else
          @deeplinks = []
        end
        @client = client
        @response = response
      end

      ##
      # Update the Bitlink. https://dev.bitly.com/v4/#operation/updateBitlink.
      # The parameters listed below are from the documentation. Some don't
      # appear to work, I am trying to get in touch with the Bitly API team to
      # confirm whether the documentation is incorrect.
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
    end
  end
end