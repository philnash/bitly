require "bundler/setup"
require "webmock/rspec"
require "vcr"
require "envyable"
require "bitly"

Envyable.load("./config/env.yml", "test")

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<CLIENT_ID>') { ENV["CLIENT_ID"] }
  config.filter_sensitive_data('<CLIENT_SECRET>') { ENV["CLIENT_SECRET"] }
  config.filter_sensitive_data('<OAUTH_CODE>') { ENV["OAUTH_CODE"] }
  config.filter_sensitive_data('<ACCESS_TOKEN>') do |interaction|
    match = interaction.response.body.match(/access_token=(\w*)&login/)
    match[1] if match && match[1]
  end
  config.filter_sensitive_data('<API_KEY>') do |interaction|
    match = interaction.response.body.match(/apiKey=(\w*)\z/)
    match[1] if match && match[1]
  end
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
