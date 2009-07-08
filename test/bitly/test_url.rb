require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestUrl < Test::Unit::TestCase
  context "a new Bitly::Url" do
    should "require either a long url, short url or hash" do
      assert_raise ArgumentError do
        Bitly::Url.new
      end
      assert_nothing_raised do
        Bitly::Url.new(login, api_key, :hash => '3j4ir4')
        Bitly::Url.new(login, api_key, :short_url => 'http://bit.ly/3j4ir4')
        Bitly::Url.new(login, api_key, :long_url => 'http://google.com/')
      end
    end
    context "shortening" do
      context "with a long url" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/shorten\?.*longUrl=.*cnn.com.*$/,"cnn.json")
          @url = Bitly::Url.new(login, api_key, :long_url => 'http://cnn.com/')
        end
        should "return a short url" do
          @url.shorten
          assert_equal "http://bit.ly/15DlK", @url.short_url
        end
      end
      # context "with no long url" do
      #   setup do
      #     @url = Bitly::Url.new(login, api_key, :hash => '15DlK')
      #   end
      # end
    end
  end
end