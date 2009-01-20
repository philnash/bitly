require 'rubygems'
require 'net/http'
require 'uri'
require 'json'

class Bitly
  attr_accessor :login, :api_key
  API_URL     = 'http://api.bit.ly/'
  API_VERSION = '2.0.1'
  
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
  
  def shorten(url)
    request = create_url "shorten", :longUrl => url
    result = JSON.parse(Net::HTTP.get(request))
    result['results'][url]['shortUrl']
  end
end