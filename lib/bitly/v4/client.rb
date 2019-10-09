module Bitly
  module V4
    # The client is the main part of this gem. You need to initialize the client with your
    # username and API key and then you will be able to use the client to perform
    # all the rest of the actions available through the API.
    class Client < Bitly::V3::Client
      base_uri 'https://api-ssl.bitly.com/v4/'
    end
  end
end
