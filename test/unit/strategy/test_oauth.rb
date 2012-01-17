require 'test_helper'

class TestOAuthStrategy < Test::Unit::TestCase
  context "with an id and secret" do
    setup do
      @client_id     = 'id'
      @client_secret = 'secret'
      @strategy      = Bitly::Strategy::OAuth.new(@client_id, @client_secret)
    end
    should 'create the oauth client' do
      assert_kind_of OAuth2::Client, @strategy.send(:client)
    end
    should 'save the strategy details on the client' do
      assert_equal @client_id,     @strategy.send(:client).id
      assert_equal @client_secret, @strategy.send(:client).secret
    end
    should 'get the oauth authorize url' do
      assert_match %r{https://api-ssl\.bit\.ly/oauth/authorize\?.*client_id=#{@client_id}.*}, @strategy.authorize_url('http://test.local')
    end
    should 'get access token with access token' do
      access_token = @strategy.get_access_token_from_token('hello')
      assert_kind_of Bitly::Strategy::AccessToken, access_token
      assert_equal @strategy.send(:client), access_token.client
    end
    should 'set access token with access token' do
      @strategy.set_access_token_from_token!('hello')
      access_token = @strategy.send(:access_token)
      assert_kind_of Bitly::Strategy::AccessToken, access_token
      assert_equal @strategy.send(:client), access_token.client
    end
  end
end
