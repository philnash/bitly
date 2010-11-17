$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'cgi'

require 'bitly/bitly'
require 'bitly/client'
require 'bitly/url'
require 'bitly/referrer'
require 'bitly/country'
require 'bitly/missing_url'