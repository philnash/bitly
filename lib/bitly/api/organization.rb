# frozen_string_literal: true
require_relative './base.rb'
require_relative './list.rb'

module Bitly
  module API
    class Organization
      include Base

      class List < Bitly::API::List ; end

      def self.list(client)
        response = client.request(path: '/organizations')
        List.new(response.body['organizations'].map { |org| Organization.new(org) }, response)
      end

      def self.fetch(client, guid)
        response = client.request(path: "/organizations/#{guid}")
        Organization.new(response.body, response)
      end

      ATTRIBUTES = [:name, :guid, :is_active, :tier, :tier_family, :tier_display_name, :role, :bsds]
      TIME_ATTRIBUTES = [:created, :modified]
      attr_reader *(ATTRIBUTES + TIME_ATTRIBUTES)

      def initialize(opts, response=nil)
        ATTRIBUTES.each do |attr|
          instance_variable_set("@#{attr}", opts[attr.to_s]) if opts[attr.to_s]
        end
        TIME_ATTRIBUTES.each do |attr|
          instance_variable_set("@#{attr}", Time.parse(opts[attr.to_s])) if opts[attr.to_s]
        end
        @response = response
      end
    end
  end
end