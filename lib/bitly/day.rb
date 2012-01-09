module Bitly

  # Day objects are created by the clicks_by_day method of a url
  class Day
    attr_reader :clicks, :day_start

    def initialize(options = {})
      @clicks    = options['clicks']
      @day_start = Time.at(options['day_start']) if options['day_start']
    end
  end
end
