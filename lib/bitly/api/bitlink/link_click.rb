# frozen_string_literal: true
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