# frozen_string_literal: true
require_relative "./base"

module Bitly
  module API
    ##
    # A User represents the authorized user
    class User
      class Email
        attr_reader :email, :is_verified, :is_primary
        def initialize(data)
          @email = data["email"]
          @is_verified = data["is_verified"]
          @is_primary = data["is_primary"]
        end
      end

      include Base
      ##
      # Gets the authorized user from the API.
      # [`GET /v4/user`](https://dev.bitly.com/v4/#operation/getUser)
      #
      # @example
      #     user = Bitly::API::User.fetch(client: client)
      #
      # @param client [Bitly::API::Client] The authorized API client
      #
      # @return [Bitly::API::User]
      def self.fetch(client:)
        response = client.request(path: "/user")
        new(data: response.body, client: client, response: response)
      end

      # @return [Array<Symbol>] The attributes the API returns for a user
      def self.attributes
        [:login, :is_active, :is_2fa_enabled, :name, :is_sso_user, :default_group_guid]
      end
      # @return [Array<Symbol>] The attributes the API returns that need to be
      # converted to `Time` objects.
      def self.time_attributes
        [:created, :modified]
      end

      attr_reader(*(attributes + time_attributes))
      attr_reader :emails

      ##
      # Creates a Bitly::API::User object.
      #
      # @example
      #     user = Bitly::API::User.new(data: user_data, client: client)
      #
      # @param data [Hash<String, String | Boolean>] The user data from the API
      # @param client [Bitly::API::Client] The authorized API client
      # @param response [Bitly::HTTP::Response] The original HTTP response
      #
      # @return [Bitly::API::User]
      def initialize(data:, client:, response: nil)
        assign_attributes(data)
        @client = client
        @response = response
        if data["emails"]
          @emails = data["emails"].map { |e| Email.new(e) }
        end
      end

      ##
      # Returns the default group for the user from the default group guid
      #
      # @example
      #     user.default_group
      #
      # @returns [Bitly::API::Group]
      def default_group
        @default_group ||= Group.fetch(client: @client, guid: default_group_guid)
      end

      ##
      # Allows you to update the authorized user's name or default group guid.
      # If you update the default group ID and have already loaded the default
      # group, it is nilled out so it can be reloaded with the correct ID.
      # [`PATCH /v4/user`](https://dev.bitly.com/v4/#operation/updateUser)]
      #
      # @example
      #     user.update(name: "New Name", default_group_guid: "aaabbb")
      #
      # @param name [String] A new name
      # @param default_group_guid [String] A new default guid
      #
      # @return [Bitly::API::User]
      def update(name: nil, default_group_guid: nil)
        params = { "name" => name }
        if default_group_guid
          params["default_group_guid"] = default_group_guid
          @default_group = nil
        end
        @response = @client.request(
          path: "/user",
          method: "PATCH",
          params: params
        )
        assign_attributes(@response.body)
        self
      end
    end
  end
end