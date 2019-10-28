# frozen_string_literal: true

module Bitly
  module API
    class Client
      USER_AGENT = "Ruby Bitly/#{Bitly::VERSION}"

      def initialize(http: Bitly::HTTP::Client.new, token:)
        @http = http
        @token = token
      end

      def request(path:, method: 'GET', params: {}, headers: {})
        params = params.select { |k,v| !v.nil? }
        headers = default_headers.merge(headers)
        uri = Bitly::API::BASE_URL.dup
        uri.path += path
        request = Bitly::HTTP::Request.new(uri: uri, method: method, params: params, headers: headers)
        @http.request(request)
      end

      def shorten(long_url, domain: nil, group_guid: nil)
        Bitlink.shorten(self, long_url, domain: domain, group_guid: group_guid)
      end

      def organizations
        Organization.list(self)
      end

      def organization(guid)
        Organization.fetch(self, guid)
      end

      def groups
        Group.list(self)
      end

      def group(guid)
        Group.fetch(self, guid)
      end

      private

      def default_headers
        {
          "User-Agent" => USER_AGENT,
          "Authorization" => "Bearer #{@token}",
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }
      end
    end
  end
end