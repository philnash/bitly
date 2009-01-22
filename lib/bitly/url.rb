module Bitly
  
  class Url
    include Bitly::Utils
    attr_reader :long_url, :short_url, :hash
    
    def initialize(login,api_key,obj=nil)
      unless obj.nil?
        instance_variablise(obj)
      end
      @login = login
      @api_key = api_key
    end
    
  end

end