require 'test_helper'

class TestClient < Test::Unit::TestCase
  context "creating a new client" do
    should "initialize with ApiKey strategy" do
      assert_nothing_raised do
        Bitly::Client.new Bitly::Strategy::ApiKey.new(login_fixture, api_key_fixture)
      end
    end
    should "initialize with OAuth strategy" do
      assert_nothing_raised do
        Bitly::Client.new Bitly::Strategy::OAuth.new(client_id_fixture, client_secret_fixture)
      end
    end
    should "raise an exception when bad arguments are used" do
      assert_raise ArgumentError do
        Bitly::Client.new("Something Else")
      end
    end
  end
end
