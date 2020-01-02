# frozen_string_literal: true
require_relative "./../base.rb"

module Bitly
  module API
    class Group
      class Preferences
        include Base

        def self.attributes
          [:group_guid, :domain_preference]
        end
        attr_reader *attributes

        def self.fetch(client:, group_guid:)
          response = client.request(path: "/groups/#{group_guid}/preferences")
          new(data: response.body, client: client, response: response)
        end

        def initialize(data:, client:, response: nil)
          assign_attributes(data)
          @client = client
          @response = response
        end

        def update(domain_preference:)
          @response = @client.request(
            path: "/groups/#{group_guid}/preferences",
            method: "PATCH",
            params: { domain_preference: domain_preference }
          )
          assign_attributes(response.body)
          self
        end
      end
    end
  end
end