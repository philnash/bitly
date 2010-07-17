require 'test_helper'

class TestMissingUrl < Test::Unit::TestCase
  context "a url" do
    setup do
      @url = Bitly::MissingUrl.new
    end
    [:short_url, :user_hash, :long_url, :error].each do |method|
      should "respond to #{method}" do
        assert_respond_to @url, method
      end
    end
  end
end