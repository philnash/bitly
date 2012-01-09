require 'test_helper'

class TestBitly < Test::Unit::TestCase
  context "bitly module" do
    context "with a login and api key" do
      should "create a new bitly client" do
        bitly = Bitly.new(:login => "login", :api_key => "api key")
        assert bitly.is_a?(Bitly::Client)
      end
      should "create have a ApiKey Strategy" do
        strategy = Bitly.new(:login => "login", :api_key => "api key").send(:strategy)
        assert strategy.is_a?(Bitly::Strategy::ApiKey)
      end
    end
    context "with a client id and client secret" do
      should "create a new bitly client" do
        bitly = Bitly.new(:client_id => "client id", :client_secret => "client secret")
        assert bitly.is_a?(Bitly::Client)
      end
      should "create have a OAuth Strategy" do
        strategy = Bitly.new(:client_id => "client id", :client_secret => "client secret").send(:strategy)
        assert strategy.is_a?(Bitly::Strategy::OAuth)
      end
    end
    context "with a client id, client secret and token" do
      should "create a new bitly client" do
        bitly = Bitly.new(:client_id => "client id", :client_secret => "client secret", :token => "token")
        assert bitly.is_a?(Bitly::Client)
      end
      should "create have a OAuth Strategy" do
        strategy = Bitly.new(:client_id => "client id", :client_secret => "client secret", :token => "token").send(:strategy)
        assert strategy.is_a?(Bitly::Strategy::OAuth)
      end
    end
    context "with bad information" do
      should "raise an error" do
        assert_raise RuntimeError do
          Bitly.new({})
        end
      end
    end
  end
end
