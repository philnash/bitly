module Bitly
  module V3
    def self.new(login, api_key)
      Bitly::V3::Client.new(login, api_key)
    end
  end
end