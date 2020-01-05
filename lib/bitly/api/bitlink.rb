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
          has_next_page? ? get_page(URI(next_url)) : nil
        end

        def prev_page
          has_prev_page? ? get_page(URI(prev_url)) : nil
        end

        private

        def get_page(uri)
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

      def self.list(client:, group_guid:)
        response = client.request(path: "/groups/#{group_guid}/bitlinks")
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
    end
  end
end