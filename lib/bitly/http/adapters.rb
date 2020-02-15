# frozen_string_literal: true

module Bitly
  module HTTP
    module Adapters
      autoload :NetHTTP, File.join(File.dirname(__FILE__), "adapters/net_http.rb")
    end
  end
end