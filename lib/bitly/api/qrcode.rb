# frozen_string_literal: true

require_relative "./base"
require_relative "./list"

module Bitly
  module API
    class Qrcode
      autoload :PaginatedList, File.join(File.dirname(__FILE__), "qrcode/paginated_list.rb")
      autoload :ScansSummary, File.join(File.dirname(__FILE__), "qrcode/scans_summary.rb")

      include Base

      class List < Bitly::API::List ; end

      def self.attributes
        [:qrcode_id, :title, :archived, :serialized_content, :long_urls, :bitlink_id, :qr_code_type, :render_customizations]
      end
      def self.time_attributes
        [:created, :updated]
      end
      attr_reader(*(attributes + time_attributes))

      ##
      # Retrieves a list of QR codes matching the filter settings. Values are in reverse chronological order. The pagination occurs by calling the next link in the pagination response object.
      # [`GET /v4/groups/{group_guid}/qr-codes`](https://dev.bitly.com/api-reference/#listQRMinimal)
      #
      # @example
      #     qrcodes = Bitly::API::Qrcode.list(client: client, group_guid: guid)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param group_guid [String] The group guid for which you want qr codes
      # @param size [Integer] The number of QR Codes to return, default 50.
      # @param archived [String] Whether or not to include archived QRCodes.
      #     One of "on", "off" or "both". Defaults to "off".
      # @param archived [String] a filter value if the QRCode has any render customizations (like color or shape changes).
      #     One of "on", "off" or "both". Defaults to "both".
      #
      # @return [Bitly::API::Qrcode::PaginatedList]
      def self.list(
        client:,
        group_guid:,
        size: nil,
        archived: nil,
        has_render_customizations: nil
      )
        params = {
          "size" => size,
          "archived" => archived,
          "has_render_customizations" => has_render_customizations
        }
        response = client.request(path: "/groups/#{group_guid}/qr-codes", params: params)
        PaginatedList.new(response: response, client: client)
      end

      ##
      # Return information about a QR Code
      # [`GET /v4/qr-codes/{qrcode_id}`](https://dev.bitly.com/api-reference/#getQRCodeByIdPublic)
      #
      # @example
      #     qrcode = Bitly::API::Qrcode.fetch(client: client, qrcode_id: "a1b2c3")
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param qrcode_id [String] The qrcode id you want information about
      #
      # @return [Bitly::API::Qrcode]
      def self.fetch(client:, qrcode_id:)
        response = client.request(path: "/qr-codes/#{qrcode_id}")
        new(data: response.body, client: client, response: response)
      end

      # [`GET /v4/qr-codes/{qrcode_id}/scans/summary`](https://dev.bitly.com/api-reference/#getScanMetricsForQRCode)
      #
      # @return [Bitly::API::Qrcode::ScansSummary]
      def scans_summary(unit: nil, units: nil, unit_reference: nil)
        ScansSummary.fetch(client: @client, qrcode_id: @qrcode_id, unit: unit, units: units, unit_reference: unit_reference)
      end

      ##
      # Return the SVG or PNG image of a QR Code
      # [`GET /v4/qr-codes/{qrcode_id}/image`](https://dev.bitly.com/api-reference/#getQRCodeImagePublic)
      #
      # @param client [Bitly::API::Client] An authorized API client
      # @param format [String] "svg" or "png". Default "svg"
      #
      # @return [String]
      def image(format: nil)
        params = format.nil? ? {} : {format: format}
        response = @client.request(path: "/qr-codes/#{qrcode_id}/image", params: params)
        response.body["qr_code_image"]
      end

      def initialize(data:, client:, response: nil)
        assign_attributes(data)
        @client = client
        @response = response
      end

      def bitlink
        Bitlink.fetch(client: @client, bitlink: @bitlink_id)
      end
    end
  end
end
