require 'test_helper'

class TestUrl < Test::Unit::TestCase
  context "a url" do
    setup do
      @url = Bitly::Url.new
    end
    [:short_url, :long_url, :user_hash, :global_hash, :user_clicks, :global_clicks, :new_hash?].each do |method|
      should "respond to #{method}" do
        assert_respond_to @url, method
      end
    end
  end
end