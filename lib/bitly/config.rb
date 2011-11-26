module Bitly
  module Config

    # bitly client options
    OPTION_KEYS = [
      :username,
      :api_key,
      :api_version
    ]

    attr_accessor *OPTION_KEYS

    def configure
      yield self
      self
    end

    def options
      options = {}
      OPTION_KEYS.each{|key| options[key] = send(key)}
      options
    end

  end
end
