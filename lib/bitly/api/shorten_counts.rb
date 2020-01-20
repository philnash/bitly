# frozen_string_literal: true
require_relative "./base"

module Bitly
  module API
    class ShortenCounts
      include Base

      def self.attributes
        [:units, :facet, :unit_reference, :unit]
      end

      attr_reader(*attributes)
      attr_reader :metrics

      Metric = Struct.new(:key, :value)

      ##
      # Shorten counts by group
      # [`GET /v4/groups/{group_guid}/shorten_counts`](https://dev.bitly.com/v4/#operation/getGroupShortenCounts)
      #
      # @example
      #     shorten_counts = Bitly::API::ShortenCounts.by_group(client: client, group_guid: group_guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param group_guid [String] The guid of the group for which you want
      #      shorten counts
      #
      # @return [Bitly::API::ShortenCounts]
      def self.by_group(client:, group_guid:)
        response = client.request(path: "/groups/#{group_guid}/shorten_counts")
        new(data: response.body, response: response)
      end

      ##
      # Shorten counts by organization
      # [`GET /v4/organizations/{organization_guid}/shorten_counts`](https://dev.bitly.com/v4/#operation/getOrganizationShortenCounts)
      #
      # @example
      #     shorten_counts = Bitly::API::ShortenCounts.by_organization(client: client, organization_guid: organization_guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param organization_guid [String] The guid of the organization for which
      #      you want shorten counts
      #
      # @return [Bitly::API::ShortenCounts]
      def self.by_organization(client:, organization_guid:)
        response = client.request(path: "/organizations/#{organization_guid}/shorten_counts")
        new(data: response.body, response: response)
      end

      def initialize(data:, response: nil)
        assign_attributes(data)
        @metrics = data["metrics"].map do |metric|
          Metric.new(metric["key"], metric["value"])
        end
        @response = response
      end
    end
  end
end