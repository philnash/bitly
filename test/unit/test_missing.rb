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
  context "#new" do
    setup do
      @url = Bitly::MissingUrl.new({ 'short_url' => 'short url',
                                     'hash'      => 'hash',
                                     'long_url'  => 'long url',
                                     'error'     => 'error' })
    end
    should "return the short url" do
      assert_equal 'short url', @url.short_url
    end
    should "return the user hash" do
      assert_equal 'hash', @url.user_hash
    end
    should "return the long url" do
      assert_equal 'long url', @url.long_url
    end
    should "return the error" do
      assert_equal 'error', @url.error
    end
  end
end
