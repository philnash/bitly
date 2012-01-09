module Bitly
  class Response
    REASONS = { "OK"          => "OK",
                "INVALID_URI" => "Invalid URI" }.freeze

    def initialize(response)
      @response = response
    end

    def success?
      parsed['status_code'] == 200
    end

    def status
      parsed['status_code']
    end

    def reason
      status = parsed['status_txt']
      REASONS[ status ] || status.split('_').map(&:capitalize) * ' '
    end

    def body
      parsed['data']
    end

    private
    def parsed
      case @response
      when OAuth2::Response
        @response.parsed
      when HTTParty::Response
        @response.parsed_response
      else
        raise "Unsupported Response type: #{@response.class}"
      end
    end
  end
end
