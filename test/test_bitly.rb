require 'test/unit'
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
    assert_equal url.class, Bitly::Url
    assert_equal url.long_url, "http://google.com"
    assert_equal url.short_url, "http://bit.ly/wQaT"
    urls = @bitly.shorten(["http://google.com","http://cnn.com"])
    assert_equal urls[0].long_url, "http://google.com"
    assert_equal urls[0].short_url, "http://bit.ly/wQaT"
  end
  
  def test_returns_a_long_url
    urls = @bitly.expand(["2bYgqR","1RmnUT"])
    assert_equal urls[0].class, Bitly::Url
    assert_equal urls[0].long_url, "http://cnn.com"
    assert_equal urls[0].hash, "2bYgqR"
    assert_equal urls[1].long_url, "http://google.com"
    assert_equal urls[1].hash, "1RmnUT"
    url = @bitly.expand("http://bit.ly/wQaT")
    assert_equal url.class, Bitly::Url
    assert_equal url.short_url, "http://bit.ly/wQaT"
    assert_equal url.long_url, "http://google.com/"
    assert_equal url.hash, "wQaT"
    url2 = @bitly.expand("wQaT")
    assert_equal url2.class, Bitly::Url
    assert_equal url2.hash, "wQaT"
    assert_equal url2.short_url, "http://bit.ly/wQaT"
    assert_equal url2.long_url, "http://google.com/"
  end
end