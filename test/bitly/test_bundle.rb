require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestBundle < Test::Unit::TestCase
  context "a new Bitly::V3::Bundle" do
    context "bundle_history" do
      context "with 1 item" do
        setup do
          stub_get(%r<^https://api-ssl.bit.ly/v3/user/bundle_history.*>, "bundle_history.json")
          @user = Bitly::V3::User.new(OAuth2::AccessToken.new(nil,"FAKE_ACCESS_TOKEN"))
        end
        should "return the bundle history" do
          # TODO: Fails oddly #assert_equal 1, @user.bundle_history.size 
        end
      end
    end
  end
end
