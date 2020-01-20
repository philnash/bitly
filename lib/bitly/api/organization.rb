# frozen_string_literal: true
require_relative "./base"
require_relative "./list"

module Bitly
  module API
    ##
    # An Organization is the top level of the Bitly user hierarchy. Both Users
    # and Groups live within an organization.
    class Organization
      include Base

      ##
      # An Organization::List is a container for a list of organizations.
      class List < Bitly::API::List ; end

      ##
      # Get a list of organizations from the API. It receives an authorized
      # `Bitly::API::Client` object and uses it to request the `/organizations`
      # endpoint.
      # [`GET /v4/organizations`](https://dev.bitly.com/v4/#operation/getOrganizations)
      #
      # @example
      #     organizations = Bitly::API::Organization.list(client: client)
      #
      # @param client [Bitly::API::Client] An authorized API client
      #
      # @return [Bitly::API::Organization::List]
      def self.list(client:)
        response = client.request(path: '/organizations')
        organizations = response.body['organizations'].map do |org|
          Organization.new(data: org, client: client)
        end
        List.new(items: organizations, response: response)
      end

      ##
      # Retrieve an organization from the API. It receives an authorized
      # `Bitly::API::Client` object and an organization guid and uses it to
      #  request the `/organizations/:organization_guid` endpoint.
      # [`GET /v4/organizations/{organization_guid}`](https://dev.bitly.com/v4/#operation/getOrganization)
      #
      # @example
      #     organization = Bitly::API::Organization.fetch(client: client, organization_guid: guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param organization_guid [String] An organization guid
      #
      # @return [Bitly::API::Organization]
      def self.fetch(client:, organization_guid:)
        response = client.request(path: "/organizations/#{organization_guid}")
        Organization.new(data: response.body, client: client, response: response)
      end

      # @return [Array<Symbol>] The attributes the API returns for an
      # organization
      def self.attributes
        [:name, :guid, :is_active, :tier, :tier_family, :tier_display_name, :role, :bsds]
      end
      # @return [Array<Symbol>] The attributes the API returns that need to be
      # converted to `Time` objects.
      def self.time_attributes
        [:created, :modified]
      end
      attr_reader(*(attributes + time_attributes))

      ##
      # Creates a new `Bitly::API::Organization` object
      #
      # @example
      #     organization = Bitly::API::Organization.new(data: org_data, client: client)
      #
      # @param data [Hash<String, String|Boolean>] Data returned from the API
      #     about the organization
      # @param client [Bitly::API::Client] An authorized API client
      # @param response [Bitly::HTTP::Response] The response object from an API
      #     call
      #
      # @return [Bitly::API::Organization]
      def initialize(data:, client:, response: nil)
        assign_attributes(data)
        @client = client
        @response = response
      end

      # @return [Bitly::API::Group::List]
      def groups
        @groups ||= Group.list(client: @client, organization: self)
      end

      ##
      # Shorten counts by organization
      # [`GET /v4/organizations/{organization_guid}/shorten_counts`](https://dev.bitly.com/v4/#operation/getOrganizationShortenCounts)
      #
      # @example
      #     shorten_counts = organization.shorten_counts
      #
      # @return [Bitly::API::ShortenCounts]
      def shorten_counts
        ShortenCounts.by_organization(client: @client, organization_guid: guid)
      end
    end
  end
end