module Bitly
  
  class Url
    include Bitly::Utils
    
    VARIABLES = ['long_url', 'short_url', 'hash', 'user_hash']
    
    def initialize(login,api_key,obj=nil)
      if obj.nil?
        
      else
        raise BitlyError.new(obj['errorMessage'],obj['errorCode'],'expand') if obj['statusCode'] == "ERROR"
        instance_variablise(obj, VARIABLES)
        raise ArgumentError.new("A Bitly::Url requires a long url, short url or a hash") if @long_url.nil? && @short_url.nil? && @hash.nil?
        @info = obj[:info] if obj[:info]
        @stats = obj[:stats] if obj[:stats]
      end
      @login = login
      @api_key = api_key
    end
    
    def shorten(opts = {})
      if @long_url
        request = create_url("shorten", :longUrl => @long_url, :history => (opts[:history] ? 1 : nil))
        result = get_result(request)[@long_url.gsub(/\/$/,'')]
        instance_variablise(result,VARIABLES)
        return @short_url
      end
    end
    
    def info
      if @info.nil?
        if @hash
          request = create_url "info", :hash => @hash
          result = get_result(request)[@hash]
          instance_variablise(result, VARIABLES)
          @info = result
        elsif @short_url
          hash = @short_url.gsub(/^.*bit.ly\//,'')
          request = create_url "info", :hash => hash
          result = get_result(request)[hash]
          instance_variablise(result, VARIABLES)
          @info = result
        else
          nil
        end
      else
        @info
      end
    end
    
    def stats
      if @stats.nil?
        if @hash
          request = create_url "stats", :hash => @hash
        elsif @short_url
          request = create_url "stats", :shortUrl => @short_url
        end
        @stats = get_result(request)
      else
        @stats
      end
    end
    
  end

end