# frozen_string_literal: true
require_relative "../base"

module Bitly
  module API
    class Bitlink
      class Deeplink
        include Base

        def self.attributes
          [:app_uri_path, :install_type, :install_url, :app_id]
        end
        attr_reader(*attributes)

        def initialize(data:)
          assign_attributes(data)
        end

        def to_json(opts=nil)
          self.class.attributes.reduce({}) do |memo, key|
            value = instance_variable_get("@#{key}")
            memo[key] = value if value
            memo
          end.to_json(opts)
        end
      end
    end
  end
end