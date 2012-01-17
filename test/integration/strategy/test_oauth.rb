require 'test_helper'

class TestOAuthStrategy < Test::Unit::TestCase
  context "with an id and secret" do
    setup do
      @client_id     = 'id'
      @client_secret = 'secret'
      @strategy      = Bitly::Strategy::OAuth.new(@client_id, @client_secret)
    end
    should 'get access token from code' do
      FakeWeb.register_uri(:post, %r|https://api-ssl.bit.ly/oauth/access_token|, { :body => "access_token=token&login=hello&apiKey=API_KEY", :content_type => 'application/x-www-form-urlencoded' })
      access_token = @strategy.get_access_token_from_code('code', 'http://test.local')
      assert_kind_of Bitly::Strategy::AccessToken, access_token
      assert_equal @strategy.send(:client), access_token.client
      assert_equal 'hello', access_token['login']
      assert_equal 'API_KEY', access_token['apiKey']
    end
    should 'get access token from token' do
      access_token = @strategy.get_access_token_from_token('token')
      assert_kind_of Bitly::Strategy::AccessToken, access_token
      assert_equal @strategy.send(:client), access_token.client
    end
  end
  context "validating a login and apiKey" do
    context "with valid login and apiKey" do
      setup do
        stub_get("https://api-ssl.bit.ly/v3/validate?x_login=test_account&x_apiKey=test_key&access_token=token", 'valid_user.json')
        @strategy = Bitly::Strategy::OAuth.new('id', 'secret')
        @strategy.set_access_token_from_token!('token')
      end
      should "return true when calling validate" do
        assert @strategy.validate(login_fixture, api_key_fixture)
      end
      should "return true when calling valid?" do
        assert @strategy.valid?(login_fixture, api_key_fixture)
      end
    end
    context "with an invalid login and apiKey" do
      setup do
        stub_get("https://api-ssl.bit.ly/v3/validate?x_login=bogus&x_apiKey=info&access_token=token", 'invalid_user.json')
        @strategy = Bitly::Strategy::OAuth.new('id', 'secret')
        @strategy.set_access_token_from_token!('token')
      end
      should "return false when calling validate" do
        assert !@strategy.validate("bogus", "info")
      end
      should "return false when calling valid?" do
        assert !@strategy.valid?("bogus", "info")
      end
    end
  end
end
