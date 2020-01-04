# frozen_string_literal: true
require_relative "./base"

module Bitly
  module API
    class OAuthApp
      include Base

      def self.attributes
        [:name, :description, :link, :client_id]
      end
      attr_reader(*attributes)

      def self.fetch(client:, client_id:)
        response = client.request(path: "/apps/#{client_id}")
        new(data: response.body, client: client, response: response)
      end

      def initialize(data:, client:, response: nil)
        assign_attributes(data)
        @client = client
        @response = response
      end
    end
  end
end