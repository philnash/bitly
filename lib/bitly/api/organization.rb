# frozen_string_literal: true

module Bitly
  module API
    class Organization
      def self.list(client)
        response = client.request(path: '/organizations')
        response.body['organizations'].map { |org| Organization.new(org) }
      end

      def self.fetch(client, guid)
        response = client.request(path: "/organizations/#{guid}")
        Organization.new(response.body)
      end

      ATTRIBUTES = [:name, :guid, :is_active, :tier, :tier_family, :tier_display_name, :role, :bsds]
      TIME_ATTRIBUTES = [:created, :modified]
      attr_reader *(ATTRIBUTES + TIME_ATTRIBUTES)

      def initialize(opts)
        ATTRIBUTES.each do |attr|
          instance_variable_set("@#{attr}", opts[attr.to_s]) if opts[attr.to_s]
        end
        TIME_ATTRIBUTES.each do |attr|
          instance_variable_set("@#{attr}", Time.parse(opts[attr.to_s])) if opts[attr.to_s]
        end
      end
    end
  end
end