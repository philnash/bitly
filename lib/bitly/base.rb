require 'rubygems'
require 'net/http'
require 'uri'
require 'json'

module Bitly
  API_URL     = 'http://api.bit.ly/'
  API_VERSION = '2.0.1'
  
  class Base
    
    def initialize(login,api_key)
      @login = login
      @api_key = api_key
    end
    
    def create_url(resource="",args={})
      args = args.merge({:login => @login, :apiKey => @api_key, :version => API_VERSION})
      url = URI.join(API_URL,resource)
      url.query = args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join("&")
      url
    end
  end
  
end