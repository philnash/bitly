# frozen_string_literal: true
require_relative "./../base.rb"

module Bitly
  module API
    class Group
      ##
      # The Preferences object represents the account preferences of a Group.
      # It includes the ability to find the domain preference for the group and
      # to update it.
      class Preferences
        include Base

        # @return [Array<Symbol>] The attributes the API returns for a group
        def self.attributes ; [:group_guid, :domain_preference] ; end
        attr_reader(*attributes)

        ##
        # Retrieve the preferences for a Group, given by the group guid
        #
        # @example
        #     preferences = Bitly::API::Group::Preferences.fetch(client: client, group_guid: group_guid)
        #
        # @param client [Bitly::API::Client] An authorized API client
        # @param group_guid [String] The guid of the groups
        #
        # @return [Bitly::API::Group::Preferences]
        def self.fetch(client:, group_guid:)
          response = client.request(path: "/groups/#{group_guid}/preferences")
          new(data: response.body, client: client, response: response)
        end

        ##
        # Creates a new Bitly::API::Group::Preferences object from the data,
        # API client and optional response.
        # [`GET /v4/groups/{group_guid}/preferences`](https://dev.bitly.com/v4/#operation/getGroupPreferences)
        #
        # @example
        #     preferences = Bitly::API::Group::Preferences.new(data: data, client: client)
        #
        # @param data [Hash<String, String>] The preferences data from the API
        # @param client [Bitly::API::Client] An authorized API client
        # @param response [Bitly::HTTP::Response] The API response object
        def initialize(data:, client:, response: nil)
          assign_attributes(data)
          @client = client
          @response = response
        end

        ##
        # Updates the preferences via the API
        # [`PATCH /v4/groups/{group_guid}/preferences`](https://dev.bitly.com/v4/#operation/updateGroupPreferences)
        #
        # @example
        #     preferences.update(domain_preference: 'bit.ly')
        #
        # @param domain_preference [String] The new domain preference for this
        #     group
        #
        # @return [Bitly::API::Group::Preferences]
        def update(domain_preference:)
          @response = @client.request(
            path: "/groups/#{group_guid}/preferences",
            method: "PATCH",
            params: { domain_preference: domain_preference }
          )
          assign_attributes(response.body)
          self
        end
      end
    end
  end
end