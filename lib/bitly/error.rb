module Bitly
  class Error < StandardError
    attr_reader :code
    alias :msg :message
    def initialize(msg, code)
      @code = code
      super("#{msg} - '#{code}'")
    end
  end
end
