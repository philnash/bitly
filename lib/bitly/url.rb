module Bitly
  
  class Url < Client
    include Bitly::Utils
    
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
          instance_variablise(result)
          @info = result
        elsif @short_url
          hash = @short_url.gsub(/^.*bit.ly\//,'')
          request = create_url "info", :hash => hash
          result = get_result(request)[hash]
          instance_variablise(result)
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
        # get info
      else
        @stats
      end
    end
    
    private
    
    VARIABLES = ['long_url', 'short_url', 'hash', 'user_hash', 'short_keyword_url']
    
  end

end