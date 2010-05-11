require 'test_helper'

class TestUrl < Test::Unit::TestCase
  context "with a client" do
    setup do
      @bitly = Bitly.new(login, api_key)
    end
    context "and a url" do
      setup do
        @url = Bitly::Url.new(@bitly)
      end
      [:short_url, :long_url, :user_hash, :global_hash, :user_clicks, :global_clicks, :new_hash?].each do |method|
        should "respond to #{method}" do
          assert_respond_to @url, method
        end
      end
    end
  
    context "and an expanded url" do
      setup do
        stub_get("http://api.bit.ly/v3/clicks?hash=9uX1TE&login=test_account&apiKey=test_key", ['9uX1TEclicks.json', '9uX1TEclicks2.json'])
        @url = Bitly::Url.new(@bitly, 'hash' => '9uX1TE')
      end
      should "get clicks when global clicks is called" do
        assert_equal 81, @url.global_clicks
      end
      should "get clicks when user clicks is called" do
        assert_equal 0, @url.user_clicks
      end
      should "get global clicks the first time and only update when forced" do
        assert_equal 81, @url.global_clicks
        assert_equal 81, @url.global_clicks
        assert_equal 82, @url.global_clicks(:force => true)
      end
      should "get user clicks the first time and only update when forced" do
        assert_equal 0, @url.user_clicks
        assert_equal 0, @url.user_clicks
        assert_equal 1, @url.user_clicks(:force => true)
      end
    end
  end
end