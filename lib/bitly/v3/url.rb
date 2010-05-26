module Bitly
  module V3
    # Url objects should only be created by the client object as it collects the correct information
    # from the API.
    class Url
      attr_reader :short_url, :long_url, :user_hash, :global_hash
    
      # Initialize with a bitly client and optional hash to fill in the details for the url.
      def initialize(client, opts={})
        @client = client
        if opts
          @short_url = opts['url']
          @long_url = opts['long_url']
          @user_hash = opts['hash'] || opts['user_hash']
          @global_hash = opts['global_hash']
          @new_hash = (opts['new_hash'] == 1)
          @user_clicks = opts['user_clicks']
          @global_clicks = opts['global_clicks']
        end
        @short_url = "http://bit.ly/#{@user_hash}" unless @short_url
      end
    
      # Returns true if the user hash was created first for this call
      def new_hash?
        @new_hash
      end
    
      # If the url already has click statistics, returns the user clicks.
      # IF there are no click statistics or <tt>:force => true</tt> is passed,
      # updates the stats and returns the user clicks
      def user_clicks(opts={})
        update_clicks_data if @global_clicks.nil? || opts[:force]
        @user_clicks
      end
    
      # If the url already has click statistics, returns the global clicks.
      # IF there are no click statistics or <tt>:force => true</tt> is passed,
      # updates the stats and returns the global clicks
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
end