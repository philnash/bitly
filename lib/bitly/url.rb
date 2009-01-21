module Bitly
  
  class Url < Base
    attr_reader :long_url, :short_url, :hash
    def shorten(url)
      @long_url = url
      request = create_url "shorten", :longUrl => url
      result = JSON.parse(Net::HTTP.get(request))
      if result['statusCode'] == "OK"
        instance_variablise(result['results'][url])
      else
        raise BitlyError.new(result['errorMessage'],result['errorCode'],'shorten')
      end
    end
    
    def expand(opts)
      if opts[:short_url]
        arg = @short_url = opts[:short_url]
        request = create_url "expand", :shortUrl => @short_url
      elsif opts[:hash]
        arg = @hash = opts[:hash]
        request = create_url "expand", :hash => @hash
      else
        return
      end
      result = JSON.parse(Net::HTTP.get(request))
      if result['statusCode'] == "OK"
        instance_variablise(result['results'][arg])
      else
        raise BitlyError.new(result['errorMessage'],result['errorCode'],'expand')
      end
    end
  end

end