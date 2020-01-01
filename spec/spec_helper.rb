# frozen_string_literal: true

require "bundler/setup"
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require "webmock/rspec"
require "vcr"
require "envyable"
require "bitly"

Envyable.load("./config/env.yml", "test")

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<CLIENT_ID>") { ENV["CLIENT_ID"] }
  config.filter_sensitive_data("<CLIENT_SECRET>") { ENV["CLIENT_SECRET"] }
  config.filter_sensitive_data("<OAUTH_CODE>") { ENV["OAUTH_CODE"] }
  config.filter_sensitive_data("<USERNAME>") { ENV["USERNAME"] }
  config.filter_sensitive_data("<PASSWORD>") { CGI.escape(ENV["PASSWORD"] || "") }
  config.filter_sensitive_data("<ACCESS_TOKEN>") do |interaction|
    match = interaction.response.body.match(/access_token=(\w*)&login/)
    match[1] if match && match[1]
  end
  config.filter_sensitive_data("<ACCESS_TOKEN>") do |interaction|
    match = interaction.response.body.match(/"access_token": "(\w*)"/)
    match[1] if match && match[1]
  end
  config.filter_sensitive_data("<API_KEY>") do |interaction|
    match = interaction.response.body.match(/apiKey=(\w*)\z/)
    match[1] if match && match[1]
  end
  config.filter_sensitive_data("<AUTH_HEADER>") do |interaction|
    auth_header = interaction.request.headers['Authorization']
    if auth_header
      match = auth_header.first.match(/Basic ([a-zA-Z0-9\+\/]+={0,3})/)
      match[1] if match && match[1]
    end
  end
  config.filter_sensitive_data("<ACCESS_TOKEN>") do |interaction|
    auth_header = interaction.request.headers['Authorization']
    if auth_header
      match = auth_header.first.match(/Bearer ([a-zA-Z0-9\+\/]+)/)
      match[1] if match && match[1]
    end
  end
  record_mode = ENV["VCR"] ? ENV["VCR"].to_sym : :once
  config.default_cassette_options = { :record => record_mode }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
