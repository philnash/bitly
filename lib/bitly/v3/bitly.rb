module Bitly
  module V3
    def self.new(login, api_key)
      Bitly::V3::Client.new(login, api_key)
    end
  end
end

class BitlyError < StandardError
  attr_reader :code
  alias :msg :message
  def initialize(msg, code)
    @code = code
    super("#{msg} - '#{code}'")
  end
end