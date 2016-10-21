require 'httparty'
require 'oauth2'
require 'bitly/config'
require 'bitly/version'
require 'bitly/error'
require 'bitly/client'
require 'bitly/country'
require 'bitly/day'
require 'bitly/missing_url'
require 'bitly/oauth'
require 'bitly/realtime_link'
require 'bitly/referrer'
require 'bitly/url'
require 'bitly/user'

module Bitly
  extend Config

  def self.new(login, api_key = nil, timeout=nil)
    Bitly::Client.new(login, api_key, timeout)
  end

  # get and initialize a client if configured using Config
  def self.client
    Bitly::Client.new(login, api_key, timeout)
  end
end
