# frozen_string_literal: true

module Bitly
  module API
    class List
      include Base
      include Enumerable

      def initialize(items, response)
        @items = items
        @response = response
      end

      def each
        @items.each { |item| yield item }
      end
    end
  end
end