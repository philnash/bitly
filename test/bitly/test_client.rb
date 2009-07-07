require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestClient < Test::Unit::TestCase
  context "bitly module" do
    should "create a new bitly client" do
      b = Bitly.new(login, api_key)
      assert_equal Bitly::Client, b.class
    end
  end
  context "using the bitly client" do
    setup do
      @bitly = Bitly.new(login, api_key)
    end
    
    context "shortening" do
      context "a single link" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/shorten\?.*longUrl=.*cnn.com.*$/,"cnn.json")
          @url = @bitly.shorten('http://cnn.com')
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return a short bitly url" do
          assert_equal "http://bit.ly/15DlK", @url.short_url
        end
        should "save the long url" do
          assert_equal "http://cnn.com", @url.long_url
        end
      end
      context "multiple links" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/shorten\?.*longUrl=.*longUrl=.*$/,"cnn_and_google.json")
          @urls = @bitly.shorten(['http://cnn.com', 'http://google.com'])
        end
        should "return an array of Bitly::Urls" do
          assert_kind_of Array, @urls
          assert_kind_of Bitly::Url, @urls[0]
        end
        should "shorten the urls in order" do
          assert_equal "http://bit.ly/15DlK", @urls[0].short_url
          assert_equal "http://bit.ly/11etr", @urls[1].short_url
        end
        should "save the long urls" do
          assert_equal "http://cnn.com", @urls[0].long_url
          assert_equal "http://google.com", @urls[1].long_url
        end
      end
      context "no links" do
        should "raise an ArgumentError" do
          assert_raise ArgumentError do
            @bitly.shorten
          end
        end
      end
    end
  end
end