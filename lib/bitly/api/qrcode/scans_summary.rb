# frozen_string_literal: true
require_relative "../base"

module Bitly
  module API
    class Qrcode
      class ScansSummary
        include Base

        def self.fetch(client:, qrcode_id:, unit: nil, units: nil, unit_reference: nil)
          response = client.request(
            path: "/qr-codes/#{qrcode_id}/scans/summary",
            params: {
              "unit" => unit,
              "units" => units,
              "unit_reference" => unit_reference
            }
          )
          new(data: response.body, response: response)
        end

        def self.attributes
          [:units, :unit, :unit_reference, :total_scans]
        end
        attr_reader(*attributes)

        def initialize(data:, response: nil)
          assign_attributes(data)
          @response = response
        end
      end
    end
  end
end
