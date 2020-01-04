# frozen_string_literal: true

module Bitly
  module API
    ##
    # A base class for lists of API resources. Implements Enumerable.
    class List
      include Enumerable

      attr_reader :response

      def initialize(items:, response:)
        @items = items
        @response = response
      end

      def each
        @items.each { |item| yield item }
      end
    end
  end
end