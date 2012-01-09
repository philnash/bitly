module Bitly
  class MissingUrl
    attr_accessor :short_url, :user_hash, :long_url, :error

    def initialize(options={})
      @error     = options['error']
      @long_url  = options['long_url']
      @short_url = options['short_url']
      @user_hash = options['hash']
    end
  end
end
