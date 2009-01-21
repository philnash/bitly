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
      url.expand(opt)
      url
    end
    
    def create_url(resource="",args={})
      args = args.merge({:login => @login, :apiKey => @api_key, :version => API_VERSION})
      url = URI.join(API_URL,resource)
      url.query = args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join("&")
      url
    end
    
    def underscore(camel_cased_word) # stolen from rails
      camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
    
    def attr_define(k,v)
      instance_variable_set("@#{k}", v)
      meta = class << self; self; end
      meta.class_eval { attr_reader k.to_sym }
    end

    def instance_variablise(obj)
      if obj.is_a? Hash
        obj.each do |k,v|
          if v.is_a? Hash
            instance_variablise(v)
          else
            attr_define(underscore(k),v)
          end
        end
      end
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