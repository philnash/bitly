module Bitly
  class Country
    attr_reader :clicks, :country

    def initialize(options = {})
      @clicks  = options['clicks']
      @country = options['country']
    end
  end
end
