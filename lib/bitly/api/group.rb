# frozen_string_literal: true
require_relative "./base"
require_relative "./list"
require_relative "./group/preferences"

module Bitly
  module API
    ##
    # A Group represents a subdivision of an Organization. Most API actions are
    # taken on behalf of a user and group and groups become a container for
    # Bitlinks and metrics.
    class Group
      include Base

      ##
      # A Group::List is a container for a list of groups.
      class List < Bitly::API::List ; end

      ##
      # Get a list of groups from the API. It receives an authorized
      # `Bitly::API::Client` object and uses it to request the `/groups`
      # endpoint, optionally passing an organization guid.
      #
      # @example
      #     groups = Bitly::API::Group.list(client: client)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param organization [Bitly::API::Organization | String] An organization
      #     object or a String representing an organization guid
      #
      # @return [Bitly::API::Group::List]
      def self.list(client:, organization: nil)
        params = {}
        if organization.is_a? Organization
          params["organization_guid"] = organization.guid
        elsif organization.is_a? String
          params["organization_guid"] = organization
        end
        response = client.request(path: "/groups", params: params)
        groups = response.body["groups"].map do |group|
          Group.new(data: group, client: client, organization: organization)
        end
        List.new(groups, response)
      end

      ##
      # Retrieve a group from the API. It receives an authorized
      # `Bitly::API::Client` object and a group guid and uses it to request
      #  the `/groups/:group_guid` endpoint.
      #
      # @example
      #     group = Bitly::API::Group.fetch(client: client, guid: guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param guid [String] A group guid
      #
      # @return [Bitly::API::Group]
      def self.fetch(client:, guid:)
        response = client.request(path: "/groups/#{guid}")
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
      # Creates a new `Bitly::API::Group` object
      #
      # @example
      #     group = Bitly::API::Group.new(data: group_data, client: client)
      #
      # @param data [Hash<String, String|Boolean>] Data returned from the API
      #     about the group
      # @param client [Bitly::API::Client] An authorized API client
      # @param respomnse [Bitly::HTTP::Response] The response object from an API
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

      # @return [Bitly::API::Organization]
      def organization
        @organization ||= Organization.fetch(client: @client, guid: organization_guid)
      end

      # @return [Bitly::API::Group::Preferences]
      def preferences
        @preferences ||= Group::Preferences.fetch(client: @client, group_guid: guid)
      end

      # @return [Array<String>]
      def tags
        @tags ||= @client.request(path: "/groups/#{guid}/tags").body["tags"]
      end

      ##
      # Allows you to update the group's name, organization or bsds.
      # If you update the organization guid and have already loaded the
      # organization, it is nilled out so it can be reloaded with the correct
      # guid
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
    end
  end
end