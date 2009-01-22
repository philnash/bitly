require 'rubygems'
require 'net/http'
require 'uri'
require 'json'

module Bitly
  API_URL     = 'http://api.bit.ly/'
  API_VERSION = '2.0.1'
  # login = 'philnash'
  # api_key = 'R_7776acc394294b2b0ad2c261a91c483d'
  class Base
    
    def initialize(login,api_key)
      @login = login
      @api_key = api_key
    end
    
    def shorten(longUrl)
      url = Bitly::Url.new(@login,@api_key)
      url.shorten(longUrl)
      url
    end
    
    def expand(opt)
      url = Bitly::Url.new(@login,@api_key)
      if opt[:short_url]
        url.expand_short_url(opt[:short_url])
      elsif opt[:hash]
        url.expand_hash(opt[:hash])
      else
        return nil
      end
      url
    end
    
  end
  
end

class BitlyError < StandardError
  attr_reader :code
  alias :msg :message
  def initialize(msg, code, req)
    @code = code
    super("'#{req}' - #{msg}")
  end
end

    # Should call something like the following:
    # 
    # Bitly::Client.login = "philnash"
    # Bitly::Client.api_key = "api_key"
    # 
    # b=Bitly.shorten("http://www.google.com") #=> Bitly::URL
    # b.longUrl #=> "http://www.google.com"
    # b.shortUrl #=> "http://bit.ly/asfsdf"
    # etc...
    # Bitly.expand({:shortUrl => shortUrl, :hash => hash}) #=> Bitly::URL
    # Bitly.info({:shortUrl => shortUrl, :hash => hash})
    # Bitly.stats({:shortUrl => shortUrl, :hash => hash})
    # 
    # Bitly.errors #=> Bitly::Errors