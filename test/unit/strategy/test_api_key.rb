require 'test_helper'

class TestApiKey < Test::Unit::TestCase
  context "creating a new ApiKey Strategy" do
    should "initialize with login and api key" do
      assert_nothing_raised do
        Bitly::Strategy::ApiKey.new(login_fixture, api_key_fixture)
      end
    end
  end
end
