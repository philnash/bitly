# frozen_string_literal: true
require_relative "./list"

module Bitly
  module API
    module BSD
      class List < Bitly::API::List ; end

      ##
      # Fetch Branded Short Domains (BSDs).
      # [`GET /v4/bsds`](https://dev.bitly.com/v4/#operation/getBSDs)
      #
      # @example
      #     bsds = Bitly::API::BSD.list(client: client)
      #
      # @return [Array<String>]
      def self.list(client:)
        response = client.request(path: "/bsds")
        bsds = response.body["bsds"]
        List.new(items: bsds, response: response)
      end
    end
  end
end