# frozen_string_literal: true
require "time"
require_relative "../base"
require_relative '../list'

module Bitly
  module API
    class Bitlink
      class LinkClick
        include Base

        class List < Bitly::API::List
          attr_reader :units, :unit_reference, :unit
          def initialize(items:, response:, units:, unit_reference:, unit:)
            super(items: items, response: response)
            @units = units
            @unit_reference = Time.parse(unit_reference) if unit_reference
            @unit = unit
          end
        end

        ##
        # Get the clicks for a bitlink.
        # [`GET /v4/bitlink/{bitlink}/clicks`](https://dev.bitly.com/v4/#operation/getClicksForBitlink)
        #
        # @param client [Bitly::API::Client] An authorized API client
        # @param bitlink [String] The Bitlink for which you want the clicks
        # @param sort [String] The data to sort on. Default and only option is
        #     "clicks".
        # @param unit [String] A unit of time. Default is "day" and can be
        #     "minute", "hour", "day", "week" or "month"
        # @param units [Integer] An integer representing the time units to query
        #     data for. pass -1 to return all units of time. Defaults to -1.
        # @param unit_reference [String] An ISO-8601 timestamp, indicating the
        #     most recent time for which to pull metrics. Will default to current
        #     time.
        # @param size [Integer] The number of links to be returned. Defaults to 50
        #
        # @return [Bitly::API::Bitlink::LinkClick::List]
        def self.list(client:, bitlink:, unit: nil, units: nil, size: nil, unit_reference: nil)
          response = client.request(
            path: "/bitlinks/#{bitlink}/clicks",
            params: {
              "unit" => unit,
              "units" => units,
              "unit_reference" => unit_reference,
              "size" => size
            }
          )
          body = response.body
          items = body["link_clicks"].map { |link_click| new(data: link_click) }
          Bitly::API::Bitlink::LinkClick::List.new(
            items: items,
            response: response,
            unit: body["unit"],
            units: body["units"],
            unit_reference: body["unit_reference"]
          )
        end

        def self.attributes
          [:clicks]
        end
        def self.time_attributes
          [:date]
        end
        attr_reader(*(attributes + time_attributes))

        def initialize(data:)
          assign_attributes(data)
        end
      end
    end
  end
end