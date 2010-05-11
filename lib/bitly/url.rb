module Bitly
  class Url
    attr_reader :short_url, :long_url, :user_hash, :global_hash
    
    def initialize(client, opts={})
      @client = client
      if opts
        @short_url = opts['url']
        @long_url = opts['long_url']
        @user_hash = opts['hash']
        @global_hash = opts['global_hash']
        @new_hash = (opts['new_hash'] == 1)
        @user_clicks = opts['user_clicks']
        @global_clicks = opts['global_clicks']
      end
      @short_url = "http://bit.ly/#{@user_hash}" unless @short_url
    end
    
    def new_hash?
      @new_hash
    end
    
    def user_clicks(opts={})
      update_clicks_data if @global_clicks.nil? || opts[:force]
      @user_clicks
    end
    
    def global_clicks(opts={})
      update_clicks_data if @global_clicks.nil? || opts[:force]
      @global_clicks
    end
    
    private
    
    def update_clicks_data
      full_url = @client.clicks(@user_hash || @short_url)
      @global_clicks = full_url.global_clicks
      @user_clicks = full_url.user_clicks
    end
  end
end