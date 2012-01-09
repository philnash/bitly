require 'test_helper'

class TestApiKey < Test::Unit::TestCase
  context "making a successful request" do
    should "return a hash when successful" do
      stub_get(%r{http://api\.bit\.ly/v3}, 'success.json')
      strategy = Bitly::Strategy::ApiKey.new(login_fixture, api_key_fixture)
      assert_kind_of Hash, strategy.request(:get, "/")
    end
  end
  context "making an unsuccessful request" do
    should "raise a bitly error when unsuccessful" do
      assert_raise BitlyError do
        stub_get(%r{http://api\.bit\.ly/v3}, 'failure.json')
        strategy = Bitly::Strategy::ApiKey.new(login_fixture, api_key_fixture)
        strategy.request(:get, "/")
      end
    end
  end
end
