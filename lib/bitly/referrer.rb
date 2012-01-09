module Bitly
  class Referrer
    attr_reader :clicks, :referrer, :referrer_app, :url

    def initialize(options)
      @url          = options['url']
      @clicks       = options['clicks']
      @referrer     = options['referrer']
      @referrer_app = options['referrer_app']
    end
  end
end
