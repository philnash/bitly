# frozen_string_literal: true
require "cgi"
require "uri"

module Bitly
  module API
    class Bitlink
      class PaginatedList < Bitly::API::List
        attr_reader :next_url, :prev_url, :size, :page, :total

        def initialize(items:, response: , client:)
          super(items: items, response: response)
          @client = client
          if response.body["pagination"]
            pagination = response.body["pagination"]
            @next_url = pagination["next"]
            @prev_url = pagination["prev"]
            @size = pagination["size"]
            @page = pagination["page"]
            @total = pagination["total"]
          end
        end

        def has_next_page?
          !next_url.nil? && !next_url.empty?
        end

        def has_prev_page?
          !prev_url.nil? && !prev_url.empty?
        end

        def next_page
          has_next_page? ? get_page(uri: URI(next_url)) : nil
        end

        def prev_page
          has_prev_page? ? get_page(uri: URI(prev_url)) : nil
        end

        private

        def get_page(uri:)
          response = @client.request(path: uri.path.gsub(/\/v4/, ""), params: CGI.parse(uri.query))
          bitlinks = response.body["links"].map do |link|
            Bitlink.new(data: link, client: @client)
          end
          self.class.new(items: bitlinks, response: response, client: @client)
        end
      end
    end
  end
end