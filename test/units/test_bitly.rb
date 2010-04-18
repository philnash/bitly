require 'test_helper'

class TestBitly < Test::Unit::TestCase
  context "bitly module" do
    should "create a new bitly client" do
      b = Bitly.new(login, api_key)
      assert b.is_a?(Bitly::Client)
    end
  end
end
