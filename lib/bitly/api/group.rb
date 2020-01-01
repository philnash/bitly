# frozen_string_literal: true
require_relative "./base.rb"
require_relative "./list.rb"

module Bitly
  module API
    class Group
      include Base

      class List < Bitly::API::List ; end

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

      def self.fetch(client:, guid:)
        response = client.request(path: "/groups/#{guid}")
        Group.new(data: response.body, client: client, response: response)
      end

      def self.attributes
        [:name, :guid, :is_active, :role, :bsds, :organization_guid]
      end
      def self.time_attributes
        [:created, :modified]
      end
      attr_reader *(attributes + time_attributes)

      def initialize(data: data, client:, response: nil, organization: nil)
        self.assign_attributes(data)
        @client = client
        @response = response
        @organization = organization
      end

      def organization
        @organization ||= Organization.fetch(@client, organization_guid)
      end
    end
  end
end