# frozen_string_literal: true
require_relative "./base"
require_relative "./list"

module Bitly
  module API
    ##
    # A Group represents a subdivision of an Organization. Most API actions are
    # taken on behalf of a user and group and groups become a container for
    # Bitlinks and metrics.
    class Group
      autoload :Preferences, File.join(File.dirname(__FILE__), "group/preferences.rb")

      include Base

      ##
      # A Group::List is a container for a list of groups.
      class List < Bitly::API::List ; end

      ##
      # Get a list of groups from the API. It receives an authorized
      # `Bitly::API::Client` object and uses it to request the `/groups`
      # endpoint, optionally passing an organization guid.
      # [`GET /v4/groups`](https://dev.bitly.com/v4/#operation/getGroups)
      #
      # @example
      #     groups = Bitly::API::Group.list(client: client)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param organization [Bitly::API::Organization | String] An organization
      #     object or a String representing an organization guid
      #
      # @return [Bitly::API::Group::List]
      def self.list(client:, organization_guid: nil)
        params = { "organization_guid" => organization_guid }
        response = client.request(path: "/groups", params: params)
        groups = response.body["groups"].map do |group|
          Group.new(data: group, client: client)
        end
        List.new(items: groups, response: response)
      end

      ##
      # Retrieve a group from the API. It receives an authorized
      # `Bitly::API::Client` object and a group guid and uses it to request
      #  the `/groups/:group_guid` endpoint.
      # [`GET /v4/groups/{group_guid}`](https://dev.bitly.com/v4/#operation/getGroup)
      #
      # @example
      #     group = Bitly::API::Group.fetch(client: client, guid: guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param guid [String] A group guid
      #
      # @return [Bitly::API::Group]
      def self.fetch(client:, group_guid:)
        response = client.request(path: "/groups/#{group_guid}")
        Group.new(data: response.body, client: client, response: response)
      end

      # @return [Array<Symbol>] The attributes the API returns for a group
      def self.attributes
        [:name, :guid, :is_active, :role, :bsds, :organization_guid]
      end
      # @return [Array<Symbol>] The attributes the API returns that need to be
      # converted to `Time` objects.
      def self.time_attributes
        [:created, :modified]
      end

      attr_reader(*(attributes + time_attributes))

      ##
      # Creates a new `Bitly::API::Group` object.
      #
      # @example
      #     group = Bitly::API::Group.new(data: group_data, client: client)
      #
      # @param data [Hash<String, String|Boolean>] Data returned from the API
      #     about the group
      # @param client [Bitly::API::Client] An authorized API client
      # @param response [Bitly::HTTP::Response] The response object from an API
      #     call
      # @param organization [Bitly::API::Organization]
      #
      # @return [Bitly::API::Group]
      def initialize(data:, client:, response: nil, organization: nil)
        assign_attributes(data)
        @client = client
        @response = response
        @organization = organization
      end

      ##
      # Fetch the organization for the group.
      # [`GET /v4/organizations/{organization_guid}`)](https://dev.bitly.com/v4/#operation/getOrganization)
      #
      # @return [Bitly::API::Organization]
      def organization
        @organization ||= Organization.fetch(client: @client, organization_guid: organization_guid)
      end

      ##
      # Fetch the group's preferences.
      # [`GET /v4/groups/{group_guid}/preferences`](https://dev.bitly.com/v4/#operation/getGroupPreferences)
      #
      # @return [Bitly::API::Group::Preferences]
      def preferences
        @preferences ||= Group::Preferences.fetch(client: @client, group_guid: guid)
      end

      ##
      # Fetch the group's tags
      # [`GET /v4/groups/{group_guid}/tags`](https://dev.bitly.com/v4/#operation/getGroupTags)
      #
      # @return [Array<String>]
      def tags
        @tags ||= @client.request(path: "/groups/#{guid}/tags").body["tags"]
      end

      ##
      # Allows you to update the group's name, organization or BSDs.
      # If you update the organization guid and have already loaded the
      # organization, it is nilled out so it can be reloaded with the correct
      # guid
      # [`PATCH /v4/groups/{group_guid}`](https://dev.bitly.com/v4/#operation/updateGroup)
      #
      # @example
      #     group.update(name: "New Name", organization_guid: "aaabbb")
      #
      # @param name [String] A new name
      # @param organization_guid [String] A new organization guid
      # @param bsds [Array<String>] An array of branded short domains
      #
      # @return [Bitly::API::Group]
      def update(name: nil, organization_guid: nil, bsds: nil)
        params = {
          "name" => name,
          "bsds" => bsds
        }
        if organization_guid
          params["organization_guid"] = organization_guid
          @organization = nil
        end
        @response = @client.request(path: "/groups/#{guid}", method: "PATCH", params: params)
        assign_attributes(@response.body)
        self
      end

      ##
      # Deletes the group.
      # [`DELETE /v4/groups/{group_guid}`](https://dev.bitly.com/v4/#operation/deleteGroup)
      #
      # @example
      #     group.delete
      #
      # @return [Nil]
      def delete
        @response = @client.request(path: "/groups/#{guid}", method: "DELETE")
        return nil
      end

      ##
      # Get the shorten counts for the group.
      # # [`GET /v4/groups/{group_guid}/shorten_counts`](https://dev.bitly.com/v4/#operation/getGroupShortenCounts)
      #
      # @return [Bitly::API::ShortenCounts]
      def shorten_counts
        ShortenCounts.by_group(client: @client, group_guid: guid)
      end

      ##
      # Gets the Bitlinks for the group.
      # [`GET /v4/groups/{group_guid}/bitlinks`](https://dev.bitly.com/v4/#operation/getBitlinksByGroup)
      #
      # @return [Bitly::API::Bitlink::List]
      def bitlinks
        Bitly::API::Bitlink.list(client: @client, group_guid: guid)
      end

      ##
      # Gets the referring networks for the group.
      # [`GET /v4/groups/{group_guid}/referring_networks`](https://dev.bitly.com/v4/#operation/GetGroupMetricsByReferringNetworks)
      #
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
      def referring_networks(unit: nil, units: nil, unit_reference: nil, size: nil)
        ClickMetric.list_referring_networks(
          client: @client,
          group_guid: guid,
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
      def countries(unit: nil, units: nil, unit_reference: nil, size: nil)
        ClickMetric.list_countries_by_group(
          client: @client,
          group_guid: guid,
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end
    end
  end
end