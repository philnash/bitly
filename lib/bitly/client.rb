module Bitly
  class Client
    include HTTParty
    base_uri 'http://api.bit.ly/v3/'
    # debug_output
    
    attr_reader :login, :api_key

    def initialize(login, api_key)
      @login = login
      @api_key = api_key
      @default_query_opts = { :login => @login, :apiKey => @api_key }
    end
    
    # Validates a login and api key
    def validate(x_login, x_api_key)
      response = get('/validate', :query => { :x_login => x_login, :x_apiKey => x_api_key })
      return response['data']['valid'] == 1
    end
    alias :valid? :validate
    
    # Checks whether a domain is a bitly.Pro domain
    def bitly_pro_domain(domain)
      response = get('/bitly_pro_domain', :query => { :domain => domain })
      return response['data']['bitly_pro_domain']
    end
    alias :pro? :bitly_pro_domain
    
    def shorten(long_url, opts={})
      query = { :longUrl => long_url }.merge(opts)
      response = get('/shorten', :query => query)
      return Bitly::Url.new(response['data'])
    end
        
    private
    
    def get(method, opts)
      opts[:query] ||= {}
      opts[:query].merge!(@default_query_opts)
      response = self.class.get(method, opts)
      if response['status_code'] == 200
        return response
      else
        raise BitlyError.new(response['status_txt'], response['status_code'])
      end
    end
    
  end
end