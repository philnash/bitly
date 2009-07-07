require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestClient < Test::Unit::TestCase
  context "bitly module" do
    should "create a new bitly client" do
      b = Bitly.new(LOGIN, API_KEY)
      assert_equal Bitly::Client, b.class
    end
  end
end