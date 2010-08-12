require 'crack'

require 'bitly/v2'
require 'bitly/v3'
require 'bitly/bitly_error'
require 'bitly/version'

module Bitly

  @version = 2

  def self.use_api_version_3
    @version = 3
  end

  def self.use_api_version_2
    @version = 2
  end

  def self.new(login, api_key)
    case @version
    when 3
      Bitly::V3::Client.new(login, api_key)
    when 2
      Bitly::V2::Client.new(login,api_key)
    else
      raise ::IllegalStateException.new("API version #{@version} is not recognized")
    end
  end

end