module Bitly
  module V3
    # Bundle objects should only be created by the user object as it collects 
    # the correct information from the API.
    class Bundle
      attr_reader :bundle_link, :bundle_owner, :created_at, 
                  :description, :last_modified_at, :title, 
                  :links, :aggregate_link

      # Initialize with a bitly user and optional hash to fill in the details for the url.
      def initialize(user, opts={})
        @user = user
        if opts
          @bundle_link = opts['bundle_link']
          @private = opts['private']
          @title = opts['title']
          @bundle_owner = opts['bundle_owner']
          @created_at = Time.at opts['created_ts'] if opts['created_ts']
          @last_modified_at = Time.at opts['last_modified_ts'] if opts['last_modified_ts']
          @aggregate_link = opts['aggregate_link']
          @description = opts['description']
          @links = opts['links'].inject([]) do |results, link|
            results << Bitly::V3::Url.new(link)
          end if opts['links']
        end
        @short_url = "http://bit.ly/#{@user_hash}" unless @short_url
      end

      # Returns true if the bundle is private to the user
      def private?
        @private
      end

      # If the url already has the title, return it.
      # IF there is no title or <tt>:force => true</tt> is passed,
      # updates the info and returns the title
      def title(opts={})
        update_contents if @title.nil? || opts[:force]
        @title
      end

      # If the bundle already has link data, return it
      # IF there are no links or <tt>:force => true</tt> is passed,
      # updates the links and returns them
      def links(opts={})
        update_contents if @links.nil? || opts[:force]
        @links
      end

      # If the url already has created at data, return it.
      # If there is no created at data or <tt>:force => true</tt> is passed,
      # updates the info and returns it
      def created_at(opts={})
        update_contents if @created_at.nil? || opts[:force]
        @created_at
      end

      private

      def update_contents
        contents = @user.bundle_contents(@bundle_link)
        @bundle_owner = contents.bundle_owner
        @created_at = contents.created_at
        @description = contents.description
        @last_modified_at = contents.last_modified_at
        @private = contents.private?
        @links = contents.links
      end

    end
  end
end
