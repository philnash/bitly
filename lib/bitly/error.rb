# frozen_string_literal: true

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
    # @return [String] The description of the failed request
    attr_reader :description

    ##
    # @return [Bitly::HTTP::Response] The response that caused the error
    attr_reader :response

    ##
    # Creates a new Bitly::Error object
    #
    # @param [Bitly::HTTP::Response] response The parsed response to the HTTP request
    def initialize(response)
      @response = response
      @status_code = response.status
      @description = response.body["description"]
      @message = "[#{@status_code}] #{response.body["message"]}"
      super(@message)
    end
  end
end