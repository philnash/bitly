# frozen_string_literal: true
require_relative "./base"
require_relative './list'

module Bitly
  module API
    class ClickMetric
      include Base

      class List < Bitly::API::List
        attr_reader :units, :unit_reference, :unit, :facet
        def initialize(items:, response:, units:, unit_reference:, unit:, facet:)
          super(items: items, response: response)
          @units = units
          # It looks like the API for referrers_by_domain returns the
          # unit_reference in seconds, not a string, like every other endpoint.
          begin
            @unit_reference = Time.parse(unit_reference) if unit_reference
          rescue TypeError
            @unit_reference = Time.at(unit_reference)
          end
          @unit = unit
          @facet = facet
        end
      end

      class Referrers < Bitly::API::List
        attr_reader :network
        def initialize(items:, response:, network:)
          super(items: items, response: response)
          @network = network
        end
      end

      def self.list_referring_networks(client:, group_guid:, unit: nil, units: nil, size: nil, unit_reference: nil)
        list_metrics(
          client: client,
          path: "/groups/#{group_guid}/referring_networks",
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      def self.list_countries_by_group(client:, group_guid:, unit: nil, units: nil, size: nil, unit_reference: nil)
        list_metrics(
          client: client,
          path: "/groups/#{group_guid}/countries",
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      def self.list_referrers(client:, bitlink:, unit: nil, units: nil, size: nil, unit_reference: nil)
        list_metrics(
          client: client,
          path: "/bitlinks/#{bitlink}/referrers",
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      def self.list_countries_by_bitlink(client:, bitlink:, unit: nil, units: nil, size: nil, unit_reference: nil)
        list_metrics(
          client: client,
          path: "/bitlinks/#{bitlink}/countries",
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      def self.list_referring_domains(client:, bitlink:, unit: nil, units: nil, size: nil, unit_reference: nil)
        list_metrics(
          client: client,
          path: "/bitlinks/#{bitlink}/referring_domains",
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      def self.list_referrers_by_domain(client:, bitlink:, unit: nil, units: nil, size: nil, unit_reference: nil)
        response = client.request(
          path: "/bitlinks/#{bitlink}/referrers_by_domains",
          params: {
            "unit" => unit,
            "units" => units,
            "unit_reference" => unit_reference,
            "size" => size
          }
        )
        body = response.body
        referrers = body["referrers_by_domain"].map do |referrer|
          click_metrics = referrer["referrers"].map do |metric|
            ClickMetric.new(data: metric)
          end
          Referrers.new(items: click_metrics, response: response, network: referrer["network"])
        end
        List.new(
          items: referrers,
          response: response,
          unit: body["unit"],
          units: body["units"],
          unit_reference: body["unit_reference"],
          facet: body["facet"]
        )
      end

      def self.attributes
        [:clicks, :value]
      end
      attr_reader(*attributes)

      def initialize(data:)
        assign_attributes(data)
      end

      private

      def self.list_metrics(client:, path:, unit:, units:, size:, unit_reference:)
        response = client.request(
          path: path,
          params: {
            "unit" => unit,
            "units" => units,
            "unit_reference" => unit_reference,
            "size" => size
          }
        )
        body = response.body
        click_metrics = body["metrics"].map do |metric|
          ClickMetric.new(data: metric)
        end
        List.new(
          items: click_metrics,
          response: response,
          unit: body["unit"],
          units: body["units"],
          unit_reference: body["unit_reference"],
          facet: body["facet"]
        )
      end
    end
  end
end