module Bitly
  ##
  # An error class that covers all potential errors from the Bitly API. In an
  # error scenario, the API is only guaranteed to return a status_code and
  # status_txt: https://dev.bitly.com/formats.html
  class Error < StandardError
    ##
    # @return [Integer] The status code of the failed request
    attr_reader :status_code

    ##
    # @return [String] The status text of the failed request
    attr_reader :status_txt

    ##
    # Creates a new Bitly::Error object
    #
    # @param [Hash] response The parsed response to the HTTP request
    # @option response [Integer] :status_code The numerical status of the
    #   request.
    # @option response [String] :status_txt A description of the failed request.
    def initialize(response)
      @message = "[#{response["status_code"]}] #{response["status_txt"]}"
      @status_code = response["status_code"]
      @status_txt = response["status_txt"]
    end
  end
end