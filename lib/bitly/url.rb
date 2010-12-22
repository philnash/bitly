module Bitly
  
  class Url
    include Bitly::Utils
    
    attr_accessor :long_url, :short_url, :hash, :user_hash
    VARIABLES = ['long_url', 'short_url', 'hash', 'user_hash']
    
    def initialize(login,api_key,obj=nil)
      unless obj.nil?
        raise BitlyError.new(obj['errorMessage'],obj['errorCode']) if obj['statusCode'] == "ERROR"
        instance_variablise(obj, VARIABLES)
        @info = obj[:info] if obj[:info]
        @stats = obj[:stats] if obj[:stats]
      end
      @login = login
      @api_key = api_key
      raise ArgumentError.new("Please provide a login and api_key") if @login.nil? || @api_key.nil?
    end
    
    def shorten(opts = {})
      return @short_url if @short_url
      unless @long_url.nil?
        request = create_url("shorten", :longUrl => @long_url, :history => (opts[:history] ? 1 : nil))
        result = get_result(request)[@long_url.gsub(/\/$/,'')]
        if result['statusCode'] == "ERROR"
          raise BitlyError.new(result['errorMessage'],result['errorCode'])
        else
          instance_variablise(result,VARIABLES)
          return @short_url
        end
      else
        raise ArgumentError.new("You need a long_url in order to shorten it")
      end
    end
    
    def expand
      return @long_url if @long_url
      unless !(@short_url || @hash)
        unless @hash
          @hash = create_hash_from_url(@short_url)
        end
        request = create_url("expand", :hash => @hash)
        result = get_result(request)[@hash]
        if result['statusCode'] == "ERROR"
          raise BitlyError.new(result['errorMessage'],result['errorCode'])
        else
          instance_variablise(result,VARIABLES)
          return @long_url
        end
      else
        raise ArgumentError.new("You need a short_url or a hash in order to expand it")
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
          @hash = create_hash_from_url(@short_url)
          request = create_url "info", :hash => hash
          result = get_result(request)[hash]
          instance_variablise(result, VARIABLES)
          @info = result
        else
          raise ArgumentError.new("You need a hash or short_url in order to get info")
        end
        return @info
      else
        @info
      end
    end
    
    def stats
      if @stats.nil?
        if @hash
          request = create_url "stats", :hash => @hash
        elsif @short_url
          @hash = create_hash_from_url(@short_url)
          request = create_url "stats", :hash => @hash
        else
          raise ArgumentError.new("You need a hash or short_url in order to get stats")
        end
        @stats = get_result(request)
      else
        @stats
      end
    end
    
    def bitly_url
      @short_url.nil? ? nil : @short_url.gsub(/j\.mp/,'bit.ly')
    end
    
    def jmp_url
      @short_url.nil? ? nil : @short_url.gsub(/bit\.ly/,'j.mp')
    end
  end

end