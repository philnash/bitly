# frozen_string_literal: true
require_relative './base.rb'
require_relative './list.rb'

module Bitly
  module API
    class Organization
      include Base

      class List < Bitly::API::List ; end

      def self.list(client:)
        response = client.request(path: '/organizations')
        List.new(response.body['organizations'].map { |org| Organization.new(data: org, client: client) }, response)
      end

      def self.fetch(client:, guid:)
        response = client.request(path: "/organizations/#{guid}")
        Organization.new(data: response.body, client: client, response: response)
      end

      def self.attributes
        [:name, :guid, :is_active, :tier, :tier_family, :tier_display_name, :role, :bsds]
      end
      def self.time_attributes
        [:created, :modified]
      end
      attr_reader *(attributes + time_attributes)

      def initialize(data: data, client:, response: nil)
        assign_attributes(data)
        @client = client
        @response = response
      end

      def groups
        @groups ||= Group.list(client: @client, organization: self)
      end
    end
  end
end