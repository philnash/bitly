# frozen_string_literal: true
require_relative "./base"

module Bitly
  module API
    class ShortenCounts
      include Base

      def self.attributes
        [:units, :facet, :unit_reference, :unit]
      end
      def self.time_attributes ; [] ; end

      attr_reader(*attributes)
      attr_reader :metrics

      Metric = Struct.new(:key, :value)

      def self.by_group(client:, guid:)
        response = client.request(path: "/groups/#{guid}/shorten_counts")
        new(data: response.body, response: response)
      end

      def self.by_organization(client:, guid:)
        response = client.request(path: "/organizations/#{guid}/shorten_counts")
        new(data: response.body, response: response)
      end

      def initialize(data:, response: nil)
        assign_attributes(data)
        @metrics = data["metrics"].map do |metric|
          Metric.new(metric["key"], metric["value"])
        end
        @response = response
      end
    end
  end
end