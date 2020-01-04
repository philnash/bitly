# frozen_string_literal: true
require_relative "./base"
require_relative "./list"
require_relative "./bitlink/deeplink"

module Bitly
  module API
    class Bitlink
      include Base

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