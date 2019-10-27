# frozen_string_literal: true
require_relative './base.rb'
require_relative './list.rb'

module Bitly
  module API
    class Group
      include Base

      class List < Bitly::API::List ; end

      def self.list(client, organization: nil)
        params = {}
        params['organization_guid'] = organization.guid if organization
        response = client.request(path: '/groups', params: params)
        List.new(response.body['groups'].map { |group| Group.new(group, client: client, organization: organization) }, response)
      end

      def self.fetch(client, guid)
        response = client.request(path: "/groups/#{guid}")
        Group.new(response.body, client: client, response: response)
      end

      def self.attributes
        [:name, :guid, :is_active, :role, :bsds, :organization_guid]
      end
      def self.time_attributes
        [:created, :modified]
      end
      attr_reader *(attributes + time_attributes)

      def initialize(opts, client:, response: nil, organization: nil)
        self.assign_attributes(opts)
        @client = client
        @response = response
        @organization = organization
      end

      def organization
        @organization ||= Organization.fetch(client, organization_guid)
      end
    end
  end
end