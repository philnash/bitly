module Bitly
  module V3
    class MissingUrl
      attr_accessor :short_url, :user_hash, :error
      def initialize(opts={})
        if opts
          @short_url = opts['short_url']
          @user_hash = opts['hash']
          @error = opts['error']
        end
      end
    end
  end
end