module Bitly
  ##
  # An error class that covers all potential errors from the Bitly API. In an
  # error scenario, the API is only guaranteed to return a status_code and
  # status_txt: https://dev.bitly.com/formats.html
  class Error < StandardError
    ##
    # @return [String] The status code of the failed request
    attr_reader :status_code

    ##
    # @return [String] The status text of the failed request
    attr_reader :status_txt

    ##
    # Creates a new Bitly::Error object
    #
    # @param [Bitly::HTTP::Response] response The parsed response to the HTTP request
    def initialize(response)
      @response = response
      @message = "[#{response.body["status_code"]}] #{response.body["status_txt"]}"
      @status_code = response.body["status_code"]
      @status_txt = response.body["status_txt"]
      super(@message)
    end
  end
end