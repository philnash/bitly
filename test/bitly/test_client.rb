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
          assert_equal "http://bit.ly/15DlK", @url.bitly_url
        end
        should "return a short jmp url" do
          assert_equal "http://j.mp/15DlK", @url.jmp_url
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
    context "expanding" do
      context "a hash" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/expand\?.*hash=31IqMl.*$/,"expand_cnn.json")
          @url = @bitly.expand("31IqMl")
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return the expanded url" do
          assert_equal "http://cnn.com/", @url.long_url
        end
        should "save the hash" do
          assert_equal "31IqMl", @url.hash
        end
        should "save the short url" do
          assert_equal "http://bit.ly/31IqMl", @url.short_url
        end
      end
      context "a short bitly url" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/expand\?.*hash=31IqMl.*$/,"expand_cnn.json")
          @url = @bitly.expand("http://bit.ly/31IqMl")
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return the expanded url" do
          assert_equal "http://cnn.com/", @url.long_url
        end
        should "save the hash" do
          assert_equal "31IqMl", @url.hash
        end
        should "save the bitly url" do
          assert_equal "http://bit.ly/31IqMl", @url.bitly_url
        end
        should "save a jmp url" do
          assert_equal "http://j.mp/31IqMl", @url.jmp_url
        end
      end
      context "a short jmp url" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/expand\?.*hash=31IqMl.*$/,"expand_cnn.json")
          @url = @bitly.expand("http://j.mp/31IqMl")
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return the expanded url" do
          assert_equal "http://cnn.com/", @url.long_url
        end
        should "save the hash" do
          assert_equal "31IqMl", @url.hash
        end
        should "save the bitly url" do
          assert_equal "http://bit.ly/31IqMl", @url.bitly_url
        end
        should "save a jmp url" do
          assert_equal "http://j.mp/31IqMl", @url.jmp_url
        end
      end
      context "multiple hashes" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/expand\?.*hash=15DlK.*3j4ir4.*$/,"expand_cnn_and_google.json")
          @urls = @bitly.expand(["15DlK","3j4ir4"])
        end
        should "return an array of Bitly::Urls" do
          assert_kind_of Array, @urls
          assert_kind_of Bitly::Url, @urls[0]
          assert_kind_of Bitly::Url, @urls[1]
        end
        should "expand the hashes in order" do
          assert_equal "http://cnn.com/", @urls[0].long_url
          assert_equal "http://google.com/", @urls[1].long_url
        end
        should "save the hash to each url" do
          assert_equal "15DlK", @urls[0].hash
          assert_equal "3j4ir4", @urls[1].hash
        end
      end
    end
    context "to get info on" do
      context "a single link" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/info\?.*hash=3j4ir4.*$/,"google_info.json")
          @url = @bitly.info('http://bit.ly/3j4ir4')
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return an info object with the url" do
          assert_not_nil @url.info
        end
      end
      context "a single hash" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/info\?.*hash=3j4ir4.*$/,"google_info.json")
          @url = @bitly.info('3j4ir4')
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return an info object with the url" do
          assert_not_nil @url.info
        end
      end
      context "a list of hashes" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/info\?.*hash=3j4ir4.*31IqMl.*$/,"google_and_cnn_info.json")
          @urls = @bitly.info(['3j4ir4','31IqMl'])
        end
        should "return a Bitly::Url" do
          assert_kind_of Array, @urls
        end
        should "return an info object with the url" do
          assert_not_nil @urls[0].info
          assert_not_nil @urls[1].info
        end
      end
    end
    context "to get stats on" do
      context "a single link" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/stats\?.*hash=3j4ir4.*$/,"google_stats.json")
          @url = @bitly.stats('http://bit.ly/3j4ir4')
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return an stats object" do
          assert_not_nil @url.stats
        end
      end
      context "a single hash" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/stats\?.*hash=3j4ir4.*$/,"google_stats.json")
          @url = @bitly.stats('3j4ir4')
        end
        should "return a Bitly::Url" do
          assert_kind_of Bitly::Url, @url
        end
        should "return an stats object" do
          assert_not_nil @url.stats
        end
      end
      context "a list of hashes" do
        should "return an argument error" do
          assert_raise ArgumentError do
            @bitly.stats(['3j4ir4','31IqMl'])
          end
        end
      end
    end
  end
end