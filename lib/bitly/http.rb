# frozen_string_literal: true

module Bitly
  module HTTP
    autoload :Adapters, File.join(File.dirname(__FILE__), "http/adapters.rb")
    autoload :Response, File.join(File.dirname(__FILE__), "http/response.rb")
    autoload :Request, File.join(File.dirname(__FILE__), "http/request.rb")
    autoload :Client, File.join(File.dirname(__FILE__), "http/client.rb")
  end
end