module Bitly
  module V3
    # Day objects are created by the realtime_links method of a user
    class RealtimeLink
      attr_reader :clicks, :user_hash
    
      def initialize(opts)
        @clicks = opts['clicks']
        @user_hash = opts['user_hash']
      end
    
      # A convenience method to create a Bitly::Url from the data
      def create_url(client)
        Bitly::V3::Url.new(client, 'user_clicks' => clicks, 'user_hash' => user_hash)
      end
    end
  end
end