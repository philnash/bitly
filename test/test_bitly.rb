require 'test/unit'
require 'rubygems'
require 'bitly'

class TestBitly < Test::Unit::TestCase
  
  def setup
    @api_key = 'R_7776acc394294b2b0ad2c261a91c483d'
    @login = 'philnash'
    @bitly = Bitly.new(@login,@api_key)
  end
  
  # not a good test, but it makes sure things are working for now.
  def test_returns_short_url
    url = @bitly.shorten("http://google.com")
    assert_kind_of Bitly::Url, url
    assert_equal "http://google.com", url.long_url
    assert_equal "http://bit.ly/wQaT", url.short_url
    urls = @bitly.shorten(["http://google.com","http://cnn.com"])
    assert_equal "http://google.com", urls[0].long_url
    assert_equal "http://bit.ly/wQaT", urls[0].short_url
		url = @bitly.shorten("http://www.google.com/search?hl=en&q=url&btnG=Google+Search&aq=f&oq=")
		assert_kind_of Bitly::Url, url
		assert_equal "http://www.google.com/search?hl=en&q=url&btnG=Google+Search&aq=f&oq=", url.long_url
		assert_equal "http://bit.ly/NqK6i", url.short_url
  end
  
  def test_returns_a_long_url
    urls = @bitly.expand(["2bYgqR","1RmnUT"])
    assert_kind_of Bitly::Url, urls[0]
    assert_equal "http://cnn.com", urls[0].long_url
    assert_equal "2bYgqR", urls[0].hash
    assert_equal "http://google.com", urls[1].long_url
    assert_equal "1RmnUT", urls[1].hash
    url = @bitly.expand("http://bit.ly/wQaT")
    assert_kind_of Bitly::Url, url
    assert_equal "http://bit.ly/wQaT", url.short_url
    assert_equal "http://google.com/", url.long_url
    assert_equal "wQaT", url.hash
    url2 = @bitly.expand("wQaT")
    assert_kind_of Bitly::Url, url2
    assert_equal "wQaT", url2.hash
    assert_equal "http://bit.ly/wQaT", url2.short_url
    assert_equal "http://google.com/", url2.long_url
  end
  
  def test_returns_keyword_url
    #kind of ghetto test but we need it to be different every time
    require 'digest/sha1'
    keyword = Digest::SHA1.hexdigest(DateTime.now.to_s)

    url = @bitly.shorten("http://google.com", keyword)
    assert_equal url.short_keyword_url, "http://bit.ly/#{keyword}"
  end

  def test_returns_error_on_existing_keyword
    keyword = 'apple'
    assert_raise BitlyError do
      @bitly.shorten("http://apple.com/itunes", keyword)
    end
  end

  
  
end
