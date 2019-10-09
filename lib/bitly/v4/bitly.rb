module Bitly
  module V4
    def self.new(login, api_key)
      Bitly::V4::Client.new(login, api_key)
    end
  end
end