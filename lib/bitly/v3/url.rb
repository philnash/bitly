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
          @short_url = opts['url'] || opts['short_url']
          @long_url = opts['long_url']
          @user_hash = opts['hash'] || opts['user_hash']
          @global_hash = opts['global_hash']
          @new_hash = (opts['new_hash'] == 1)
          @user_clicks = opts['user_clicks']
          @global_clicks = opts['global_clicks']
          @title = opts['title']
          @created_by = opts['created_by']
          @referrers = opts['referrers'].inject([]) do |results, referrer|
            results << Bitly::V3::Referrer.new(referrer)
          end if opts['referrers']
          @countries = opts['countries'].inject([]) do |results, country|
            results << Bitly::V3::Country.new(country)
          end if opts['countries']
          if opts['clicks'] && opts['clicks'][0].is_a?(Hash)
            @clicks_by_day = opts['clicks'].inject([]) do |results, day|
              results << Bitly::V3::Day.new(day)
            end
          else
            @clicks_by_minute = opts['clicks']
          end
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
      
      # If the url already has the title, return it.
      # IF there is no title or <tt>:force => true</tt> is passed,
      # updates the info and returns the title
      def title(opts={})
        update_info if @title.nil? || opts[:force]
        @title
      end
      
      # If the url already has the creator, return it.
      # IF there is no creator or <tt>:force => true</tt> is passed,
      # updates the info and returns the creator
      def created_by(opts={})
        update_info if @created_by.nil? || opts[:force]
        @created_by
      end
    
      # If the url already has referrer data, return it.
      # IF there is no referrer or <tt>:force => true</tt> is passed,
      # updates the referrers and returns them
      def referrers(opts={})
        update_referrers if @referrers.nil? || opts[:force]
        @referrers
      end

      # If the url already has country data, return it.
      # IF there is no country or <tt>:force => true</tt> is passed,
      # updates the countries and returns them
      def countries(opts={})
        update_countries if @countries.nil? || opts[:force]
        @countries
      end

      def clicks_by_minute(opts={})
        if @clicks_by_minute.nil? || opts[:force]
          full_url = @client.clicks_by_minute(@user_hash || @short_url)
          @clicks_by_minute = full_url.clicks_by_minute
        end
        @clicks_by_minute
      end

      def clicks_by_day(opts={})
        if @clicks_by_day.nil? || opts[:force]
          full_url = @client.clicks_by_day(@user_hash || @short_url)
          @clicks_by_day = full_url.clicks_by_day
        end
        @clicks_by_day
      end
      
      private
    
      def update_clicks_data
        full_url = @client.clicks(@user_hash || @short_url)
        @global_clicks = full_url.global_clicks
        @user_clicks = full_url.user_clicks
      end
      
      def update_info
        full_url = @client.info(@user_hash || @short_url)
        @created_by = full_url.created_by
        @title = full_url.title
      end
      
      def update_referrers
        full_url = @client.referrers(@user_hash || @short_url)
        @referrers = full_url.referrers
      end

      def update_countries
        full_url = @client.countries(@user_hash || @short_url)
        @countries = full_url.countries
      end
    end
  end
end