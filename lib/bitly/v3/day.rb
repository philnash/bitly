module Bitly
  module V3
    # Day objects are created by the clicks_by_day method of a url
    class Day
      attr_reader :clicks, :day_start
    
      def initialize(opts)
        @clicks = opts['clicks']
        @day_start = Time.at(opts['day_start']) if opts['day_start']
      end
    end
  end
end