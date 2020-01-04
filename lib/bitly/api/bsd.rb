# frozen_string_literal: true
require_relative "./list"

module Bitly
  module API
    module BSD
      class List < Bitly::API::List ; end

      def self.list(client:)
        response = client.request(path: "/bsds")
        bsds = response.body["bsds"]
        List.new(items: bsds, response: response)
      end
    end
  end
end