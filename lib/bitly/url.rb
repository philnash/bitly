module Bitly
  
  class Url
    include Bitly::Utils
    
    VARIABLES = ['long_url', 'short_url', 'hash', 'user_hash', 'short_keyword_url']
    
    def initialize(login,api_key,obj=nil)
      unless obj.nil?
        instance_variablise(obj, VARIABLES)
        @info = obj[:info] if obj[:info]
        @stats = obj[:stats] if obj[:stats]
      end
      @login = login
      @api_key = api_key
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