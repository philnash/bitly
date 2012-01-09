$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'oauth2'
require 'cgi'
require 'forwardable'

module Bitly
  def self.new(params = {})
    params.symbolize_keys!
    if params.key?(:client_id) && params.key?(:client_secret)
      strategy = Bitly::Strategy::OAuth.new(params[:client_id], params[:client_secret])
      strategy.get_access_token_from_token(params[:token]) if params[:token]
      Bitly::Client.new strategy
    elsif params.key?(:login) && params.key?(:api_key)
      Bitly::Client.new Bitly::Strategy::ApiKey.new(params[:login], params[:api_key])
    else
      raise "requires a login and apiKey or client id and client secret"
    end
  end
end

require 'bitly/client'
require 'bitly/country'
require 'bitly/day'
require 'bitly/error'
require 'bitly/missing_url'
require 'bitly/realtime_link'
require 'bitly/referrer'
require 'bitly/response'
require 'bitly/url'
require 'bitly/user'
require 'bitly/strategy/base'
require 'bitly/strategy/access_token'
require 'bitly/strategy/api_key'
require 'bitly/strategy/oauth'

require 'bitly/lib/core_ext/hash'
require 'bitly/lib/core_ext/string'
