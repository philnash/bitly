# frozen_string_literal: true
require_relative "../paginated_list"

module Bitly
  module API
    class Bitlink
      class PaginatedList < Bitly::API::PaginatedList
        def item_key
          "links"
        end

        def item_factory(data)
          Bitlink.new(data: data, client: @client)
        end
      end
    end
  end
end
