require 'rubygems'
require 'net/http'
require 'uri'
require 'json'

module Bitly
  API_URL     = 'http://api.bit.ly/'
  API_VERSION = '2.0.1'
  # login = 'philnash'
  # api_key = 'R_7776acc394294b2b0ad2c261a91c483d'
  class Client
    
    include Bitly::Utils
    
    def initialize(login,api_key)
      @login = login
      @api_key = api_key
    end
    
    def shorten(input)
      if input.is_a? String
        request = create_url "shorten", :longUrl => input
        result = get_result(request)
        result = {:long_url => input}.merge result[input]
        Bitly::Url.new(@login,@api_key,result)
      elsif input.is_a? Array
        request = create_url "shorten"
        request.query << "&" + input.map { |long_url| "longUrl=#{URI.encode(long_url)}" }.join("&") unless input.nil?
        result = get_result(request)
        input.map do |long_url|
          new_url = {:long_url => long_url}.merge result[long_url]
          long_url = Bitly::Url.new(@login,@api_key,new_url)
        end
      else
        raise ArgumentError
      end
    end
    
    def expand(input)
      if input.is_a? String
        if input.include? "bit.ly/"
          hash = input.gsub(/^.*bit.ly\//,'')
          request = create_url "expand", :hash => hash
          result = get_result(request)
          result = { :short_url => input, :hash => hash }.merge result[hash]
        else
          request = create_url "expand", :hash => input
          result = get_result(request)
          result = { :hash => input }.merge result[input]
        end
        Bitly::Url.new(@login,@api_key,result)        
      elsif input.is_a? Array
        request = create_url "expand", :hash => input.join(',')
        result = get_result(request)
        input.map do |hsh|
          new_url = {:hash => hsh}.merge result[hsh]
          hsh = Bitly::Url.new(@login,@api_key,new_url)
        end
      else
        raise ArgumentError
      end
    end
    
    private

    def create_url(resource="",args={})
      args = args.merge({:login => @login, :apiKey => @api_key, :version => API_VERSION})
      url = URI.join(API_URL,resource)
      long_urls = args.delete(:long_urls)
      url.query = args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join("&")
      url.query << "&" + long_urls.map { |long_url| "longUrl=#{URI.encode(long_url)}" }.join("&") unless long_urls.nil?
      url
    end
    
    def get_result(request)
      result = JSON.parse(Net::HTTP.get(request))
      if result['statusCode'] == "OK"
        result = result['results']
      else
        raise BitlyError.new(result['errorMessage'],result['errorCode'],'expand')
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


# How it should work
# ==================
# bitly = Bitly::Base.new('philnash','R_7776acc394294b2b0ad2c261a91c483d')
# bitly.shorten("http://www.google.com")
# #=> Bitly::Url
# bitly.shorten(["http://www.google.com","http://cnn.com"])
# #=> [Bitly::Url,Bitly::Url]
# 
# bitly.expand("http://bit.ly/wIRm")
# #=> Bitly::Url
# bitly.expand("wIRm")
# #=> Bitly::Url
# bitly.expand(["wIRm","sdfsd"])
# #=> [Bitly::Url,Bitly::Url]
#
# bitly.info("http://bit.ly/wIRm") || bitly.info("wIRm")
# #=> b = Bitly::Url
# #=> b.info #=> hash of data back from info
# bitly.info(['wIRm','qsads'])
# #=> [Bitly::Url, Bitly::Url]
# also, with any url = Bitly::Url
# url.info #=> hash of info data

# bitly.stats("http://bit.ly/wIRm") || bitly.stats("wIRm")
# #=> b = Bitly::Url
# #=> b.stats #=> hash of stats
# also, any url = Bitly::Url
# url.stats #=> hash of stats