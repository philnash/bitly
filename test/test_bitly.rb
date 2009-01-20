require 'test/unit'
require 'bitly'

class TestBitly < Test::Unit::TestCase
  
  def setup
    @api_key = 'test_key'
    @login = 'login'
    @bitly = Bitly.new(@login,@api_key)
  end
  
  def test_initializer_sets_required_parameters
    assert_equal @bitly.api_key, @api_key
    assert_equal @bitly.login, @login
  end
  
  def test_creates_url_parameters
    url = @bitly.create_url.request_uri
    assert url.include?("login=#{@login}")
    assert url.include?("apiKey=#{@api_key}")
  end
end