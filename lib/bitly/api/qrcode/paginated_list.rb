# frozen_string_literal: true
require_relative "../paginated_list"

module Bitly
  module API
    class Qrcode
      class PaginatedList < Bitly::API::PaginatedList
        def item_key
          "qr_codes"
        end

        def item_factory(data)
          Qrcode.new(data: data, client: @client)
        end
      end
    end
  end
end
