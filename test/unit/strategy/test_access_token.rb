require 'test_helper'

class TestAccessToken < Test::Unit::TestCase
  context "with an id and secret" do
    setup do
      oauth     = Bitly::Strategy::OAuth.new('id', 'secret')
      @strategy = oauth.get_access_token_from_token('token')
    end
    should 'get access token with access token' do
      access_token = @strategy.send(:access_token)
      assert_kind_of OAuth2::AccessToken, access_token
    end
  end
end
