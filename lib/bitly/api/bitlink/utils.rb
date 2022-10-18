# frozen_string_literal: true

module Bitly
  module API
    class Bitlink
      module Utils
        def self.normalise_bitlink(bitlink:)
          bitlink.gsub(/^https?:\/\//, "")
        end
      end
    end
  end
end