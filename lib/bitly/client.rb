require 'rubygems'
require 'net/http'
require 'uri'

module Bitly
  API_URL     = 'http://api.bit.ly/'
  API_VERSION = '2.0.1'

  def self.new(login, api_key)
    Bitly::Client.new(login,api_key)
  end

  class Client
    
    include Bitly::Utils
    
    def initialize(login,api_key)
      @login = login
      @api_key = api_key
    end

    def shorten(input, opts={})
      if input.is_a? String
        request = create_url("shorten", :longUrl => input, :history => (opts[:history] ? 1 : nil))
        result = get_result(request)
        result = {:long_url => input}.merge result[input]
        Bitly::Url.new(@login,@api_key,result)
      elsif input.is_a? Array
        request = create_url("shorten", :history => (opts[:history] ? 1 : nil))
        request.query << "&" + input.map { |long_url| "longUrl=#{CGI.escape(long_url)}" }.join("&") unless input.nil?
        result = get_result(request)
        input.map do |long_url|
          new_url = {:long_url => long_url}.merge result[long_url]
          long_url = Bitly::Url.new(@login,@api_key,new_url)
        end
      else
        raise ArgumentError.new("Shorten requires either a url or an array of urls")
      end
    end
    
    def expand(input)
      if input.is_a? String
        if input.include?('bit.ly/') || input.include?('j.mp/')
          hash = create_hash_from_url(input)
          request = create_url "expand", :hash => hash
          result = get_result(request)
          result = { :short_url => input, :hash => hash }.merge result[hash]
        else
          request = create_url "expand", :hash => input
          result = get_result(request)
          result = { :hash => input, :short_url => "http://bit.ly/#{input}" }.merge result[input]
        end
        Bitly::Url.new(@login,@api_key,result)        
      elsif input.is_a? Array
        request = create_url "expand", :hash => input.join(',')
        result = get_result(request)
        input.map do |hsh|
          new_url = {:hash => hsh, :short_url => "http://bit.ly/#{hsh}"}.merge result[hsh]
          hsh = Bitly::Url.new(@login,@api_key,new_url)
        end
      else
        raise ArgumentError('Expand requires either a short url, a hash or an array of hashes')
      end
    end
    
    def info(input)
      if input.is_a? String
        if input.include? "bit.ly/"
          hash = create_hash_from_url(input)
          request = create_url 'info', :hash => hash
          result = get_result(request)
          result = { :short_url => "http://bit.ly/#{hash}", :hash => hash }.merge result[hash]
        else
          request = create_url 'info', :hash => input
          result = get_result(request)
          result = { :short_url => "http://bit.ly/#{input}", :hash => input }.merge result[input]
        end
        Bitly::Url.new(@login,@api_key,result)
      elsif input.is_a? Array
        request = create_url "info", :hash => input.join(',')
        result = get_result(request)
        input.map do |hsh|
          new_url = {:hash => hsh, :short_url => "http://bit.ly/#{hsh}"}.merge result[hsh]
          hsh = Bitly::Url.new(@login,@api_key,:info => new_url)
        end
      else
        raise ArgumentError.new('Info requires either a short url, a hash or an array of hashes')
      end
    end
    
    def stats(input)
      if input.is_a? String
        if input.include? "bit.ly/"
          hash = create_hash_from_url(input)
          request = create_url 'stats', :hash => hash
          result = get_result(request)
          result = { :short_url => "http://bit.ly/#{hash}", :hash => hash }.merge result
        else
          request = create_url 'stats', :hash => input
          result = get_result(request)
          result = { :short_url => "http://bit.ly/#{input}", :hash => input }.merge result
        end
        Bitly::Url.new(@login,@api_key,:stats => result)
      else
        raise ArgumentError.new("Stats requires either a short url or a hash")
      end
    end
    
  end
  
end

class BitlyError < StandardError
  attr_reader :code
  alias :msg :message
  def initialize(msg, code)
    @code = code
    super("#{msg} - '#{code}'")
  end
end