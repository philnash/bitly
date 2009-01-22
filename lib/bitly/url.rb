module Bitly
  
  class Url < Base
    attr_reader :long_url, :short_url, :hash
    
    def shorten(url)
      call(:long_url => url)
    end
    
    def expand_hash(hash)
      call(:hash => hash)
    end
    
    def expand_short_url(url)
      call(:short_url => url)
    end
    
    private
    
    def call(opts)
      if opts[:short_url]
        arg = @short_url = opts[:short_url]
        request = create_url "expand", :shortUrl => @short_url
      elsif opts[:hash]
        arg = @hash = opts[:hash]
        request = create_url "expand", :hash => @hash
      elsif opts[:long_url]
        arg = @long_url = opts[:long_url]
        request = create_url "shorten", :longUrl => @long_url
      end
      result = JSON.parse(Net::HTTP.get(request))
      if result['statusCode'] == "OK"
        instance_variablise(result['results'][arg])
      else
        raise BitlyError.new(result['errorMessage'],result['errorCode'],'expand')
      end
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