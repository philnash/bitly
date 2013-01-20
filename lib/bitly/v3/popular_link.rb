module Bitly
  module V3
    
    class PopularLink
      attr_reader :clicks, :link
    
      def initialize(opts)
        @clicks = opts['clicks']
        @link = opts['link']
      end

    end
  end
end