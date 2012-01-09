require 'test_helper'

class TestRealtimeLink < Test::Unit::TestCase
  context "a realtime link" do
    setup do
      @realtime_link = Bitly::RealtimeLink.new
    end
    [:clicks, :user_hash].each do |method|
      should "respond to #{method}" do
        assert_respond_to @realtime_link, method
      end
    end
    should "set clicks when initializing" do
      realtime_link = Bitly::RealtimeLink.new('clicks' => 12)
      assert_equal 12, realtime_link.clicks
    end
    should "set user_hash when initializing" do
      realtime_link = Bitly::RealtimeLink.new('user_hash' => 'sdfidn')
      assert_equal 'sdfidn', realtime_link.user_hash
    end
    should 'create a url when supplied with a client' do
      realtime_link = Bitly::RealtimeLink.new('user_hash' => 'sdfidn', 'clicks' => 12)
      client = Bitly::Client.new(Bitly::Strategy::ApiKey.new(login_fixture, api_key_fixture))
      url = realtime_link.create_url(client)
      assert_kind_of Bitly::Url, url
      assert_equal 12, url.user_clicks
      assert_equal 'sdfidn', url.user_hash
    end
  end
end
