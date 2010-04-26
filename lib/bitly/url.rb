module Bitly
  class Url
    attr_accessor :short_url, :long_url, :user_hash, :global_hash
    
    def initialize(opts={})
      if opts
        @short_url = opts['url']
        @long_url = opts['long_url']
        @user_hash = opts['hash']
        @global_hash = opts['global_hash']
        @new_hash = (opts['new_hash'] == 1)
      end
      @short_url = "http://bit.ly/#{@user_hash}" unless @short_url
    end
    
    def new_hash?
      @new_hash
    end
  end
end