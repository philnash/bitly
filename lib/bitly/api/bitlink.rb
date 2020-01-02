# frozen_string_literal: true
require_relative './base.rb'
require_relative './list.rb'

module Bitly
  module API
    class Bitlink
      include Base

      def self.shorten(client:, long_url:, domain: nil, group_guid: nil)
        response = client.request(path: '/shorten', method: 'POST', params: { long_url: long_url, domain: domain, group_guid: group_guid })
        Bitlink.new(response.body, client: client, response: response)
      end

      def self.attributes
        [:archived, :tags, :title, :created_by, :long_url, :client_id, :custom_bitlinks, :link, :id]
      end
      def self.time_attributes
        [:created_at]
      end
      attr_reader *(attributes + time_attributes)

      def initialize(data:, client:, response: nil)
        assign_attributes(data)
        @client = client
        @response = response
      end
    end
  end
end