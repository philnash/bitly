# frozen_string_literal: true

require "bitly/version"

module Bitly
  autoload :Error, "bitly/error"
  autoload :OAuth, "bitly/oauth"
  autoload :HTTP, "bitly/http"
  autoload :API, "bitly/api"
end
