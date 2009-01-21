module Bitly
  
  class LongURL < Base
    
    def shorten(url)
      request = create_url "shorten", :longUrl => url
      result = JSON.parse(Net::HTTP.get(request))
      result['results'][url]['shortUrl']
    end
  end
end