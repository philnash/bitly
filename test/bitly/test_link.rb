require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestLink < Test::Unit::TestCase
  context "Link Metrics::clicks" do
    setup do
      token = OAuth2::AccessToken.new(nil, "<access_token>")
      @link = Bitly::V3::Link.new(token)      
      @url = /^https:\/\/api-ssl.bit.ly\/v3\/link\/clicks\?.*link=.*bit.ly.*$/
      @content_type = "application/json; charset=utf-8"
    end
    
    should "return rolled-up clicks" do
      body = fixture_file("link_clicks_rollup_true.json")
      FakeWeb.register_uri(:get, @url, :body => body, :content_type => @content_type)
      
      clicks = @link.clicks("http://bit.ly/123abc")
      assert_equal 701, clicks
    end
    
    should "return detailed clicks" do
      body = fixture_file("link_clicks_rollup_false.json")
      FakeWeb.register_uri(:get, @url, :body => body, :content_type => @content_type)
      
      clicks = @link.clicks("http://bit.ly/123abc", :rollup => false)
      assert_equal [{:time=>Time.parse("2012-09-24 00:00:00 -0400"), :clicks=>4}, {:time=>Time.parse("2012-09-22 00:00:00 -0400"), :clicks=>4}], clicks
    end
  end
end