class BitlyError < StandardError
  attr_reader :code, :response

  alias :msg :message

  def initialize(response)
    @response = response
    @message  = response.reason
    @code     = response.status

    super("#{@message} - '#{@code}'")
  end
end
