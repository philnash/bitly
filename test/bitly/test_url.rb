require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestUrl < Test::Unit::TestCase
  context "a new Bitly::Url" do
    should "require a login and api_key" do
      assert_raise ArgumentError do Bitly::Url.new end
      assert_raise ArgumentError do Bitly::Url.new(login) end
      assert_raise ArgumentError do Bitly::Url.new(nil, api_key) end
      assert_nothing_raised do
        Bitly::Url.new(login, api_key)
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
          assert_equal "http://bit.ly/15DlK", @url.shorten
        end
        should "create bitly and jmp urls" do
          @url.shorten
          assert_equal "http://bit.ly/15DlK", @url.bitly_url
          assert_equal "http://j.mp/15DlK", @url.jmp_url
        end
      end
      context "with no long url" do
        setup do
          @url = Bitly::Url.new(login, api_key)
        end
        should "raise an error" do
          assert_raise ArgumentError do
            @url.shorten
          end
        end
      end
      context "with a short url already" do
        setup do
          @url = Bitly::Url.new(login, api_key, :short_url => 'http://bit.ly/31IqMl')
          flexmock(@url).should_receive(:create_url).never
        end
        should "not need to call the api" do
          assert_equal "http://bit.ly/31IqMl", @url.shorten
        end
      end
    end
    context "expanding" do
      context "with a hash" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/expand\?.*hash=31IqMl.*$/,"expand_cnn.json")
          @url = Bitly::Url.new(login, api_key, :hash => '31IqMl')
        end
        should "return an expanded url" do
          assert_equal "http://cnn.com/", @url.expand
        end
      end
      context "with a short url" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/expand\?.*hash=31IqMl.*$/,"expand_cnn.json")
          @url = Bitly::Url.new(login, api_key, :short_url => 'http://bit.ly/31IqMl')
        end
        should "return an expanded url" do
          assert_equal "http://cnn.com/", @url.expand
        end
      end
      context "with no short url or hash" do
        setup do
          @url = Bitly::Url.new(login, api_key)
        end
        should "raise an error" do
          assert_raise ArgumentError do
            @url.expand
          end
        end
      end
      context "with a long url already" do
        setup do
          @url = Bitly::Url.new(login, api_key, :long_url => 'http://google.com')
          flexmock(@url).should_receive(:create_url).never
        end
        should "not need to call the api" do
          assert_equal "http://google.com", @url.expand
        end
      end
    end
    context "info" do
      context "with a hash" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/info\?.*hash=3j4ir4.*$/,"google_info.json")
          @url = Bitly::Url.new(login, api_key, :hash => '3j4ir4')
        end
        should "return info" do
          assert_equal "Google", @url.info['htmlTitle']
        end
      end
      context "with a short url" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/info\?.*hash=3j4ir4.*$/,"google_info.json")
          @url = Bitly::Url.new(login, api_key, :short_url => 'http://bit.ly/3j4ir4')
        end
        should "return an expanded url" do
          assert_equal "Google", @url.info['htmlTitle']
        end
      end
      context "without a short url or hash" do
        setup do
          @url = Bitly::Url.new(login, api_key, :long_url => 'http://google.com')
        end
        should "raise an error" do
          assert_raise ArgumentError do
            @url.info
          end
        end
      end
      context "with info already" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/info\?.*hash=3j4ir4.*$/,"google_info.json")
          @url = Bitly::Url.new(login, api_key, :short_url => 'http://bit.ly/3j4ir4')
          @url.info
        end
        should "not call the api twice" do
          flexmock(@url).should_receive(:create_url).never
          @url.info
        end
      end
    end
    context "stats" do
      context "with a hash" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/stats\?.*hash=3j4ir4.*$/,"google_stats.json")
          @url = Bitly::Url.new(login, api_key, :hash => '3j4ir4')
        end
        should "return info" do
          assert_equal 2644, @url.stats['clicks']
        end
      end
      context "with a short url" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/stats\?.*hash=3j4ir4.*$/,"google_stats.json")
          @url = Bitly::Url.new(login, api_key, :short_url => 'http://bit.ly/3j4ir4')
        end
        should "return an expanded url" do
          assert_equal 2644, @url.stats['clicks']
        end
      end
      context "without a short url or hash" do
        setup do
          @url = Bitly::Url.new(login, api_key, :long_url => 'http://google.com')
        end
        should "raise an error" do
          assert_raise ArgumentError do
            @url.stats
          end
        end
      end
      context "with info already" do
        setup do
          stub_get(/^http:\/\/api.bit.ly\/stats\?.*hash=3j4ir4.*$/,"google_stats.json")
          @url = Bitly::Url.new(login, api_key, :short_url => 'http://bit.ly/3j4ir4')
          @url.stats
        end
        should "not call the api twice" do
          flexmock(@url).should_receive(:create_url).never
          @url.stats
        end
      end
    end
  end
end