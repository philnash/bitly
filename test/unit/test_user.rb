require 'test_helper'

class TestUser < Test::Unit::TestCase
  context "with an access_token" do
    setup do
      consumer     = Bitly::Strategy::OAuth.new('consumer_token', 'consumer_secret')
      access_token = consumer.get_access_token_from_token('token', 'login' => 'login', 'apiKey' => 'api_key')
      @user        = Bitly::User.new(access_token)
    end

    context 'the user' do
      should 'get a client' do
        assert_kind_of Bitly::Client, @user.client
      end
    end
  end
end
