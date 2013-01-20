require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestClient < Test::Unit::TestCase
  
  context "User" do

    setup do
      client = Bitly::V3::OAuth.new('blah', 'blahh')
      access_token = OAuth2::AccessToken.new(client, 'token')
      @user = Bitly::V3::User.new(access_token)
    end
    
    should "be able to edit link metadata" do                 
      link = 'http://bit.ly/JGVkUk'
      params = {
        :title => 'title',
        :note => 'a note',
        :private => true,
        :user_ts => Time.now.to_i,
        :archived => false
      }      
      
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/link_edit.+$/, 'link_edit.json')
            
      response = @user.link_edit(link, params)
      assert_equal link, response
    end
    
    should "be able to lookup a link" do
      expected = {
        'aggregate_link' => 'http://bit.ly/2V6CFi',
        'url' => 'http://www.google.com/'
      }
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/link_lookup.+$/, 'user_link_lookup.json')
      
      response = @user.link_lookup(expected['url'])
      
      assert_kind_of Hash, response
      assert response.has_key?('aggregate_link')
      assert response.has_key?('url')
      assert_equal expected['aggregate_link'], response['aggregate_link']
      assert_equal expected['url'], response['url']      
    end
    
    should "be able to look up referrers" do
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/referrers.+$/, 'user_referrers.json')
      response = @user.referrers
      assert_kind_of Array, response
      response.each do |day|
        assert_kind_of Array, day
        day.each do |referrer|
          assert_kind_of Bitly::V3::Referrer, referrer
          assert_not_nil referrer.clicks
          assert_not_nil referrer.referrer
        end
      end
    end
    
    should "be able to look up referring countries" do
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/countries.+$/, 'user_countries.json')
      response = @user.countries
      assert_kind_of Array, response
      response.each do |day|
        assert_kind_of Array, day
        day.each do |country|
          assert_kind_of Bitly::V3::Country, country
          assert_not_nil country.clicks
          assert_not_nil country.country
        end
      end
    end
    
    should "be able to look up popular links" do
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/popular_links.+$/, 'user_popular_links.json')
      response = @user.popular_links
      
      assert_kind_of Array, response
      response.each do |link|
        assert_kind_of Bitly::V3::PopularLink, link
        assert_not_nil link.clicks
        assert_kind_of Fixnum, link.clicks
        assert_not_nil link.link
        assert_kind_of String, link.link
      end
    end
    
    should "be able to get the aggregate number of clicks on all of the authenticated user's bitly links" do
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/clicks.+$/, 'user_clicks.json')
      response = @user.clicks
      
      assert_kind_of Array, response
      response.each do |day|
        assert_kind_of Bitly::V3::Day, day
        assert_not_nil day.clicks
        assert_kind_of Fixnum, day.clicks
        assert_not_nil day.day_start
        assert_kind_of Time, day.day_start
      end      
    end
    
    should "be able to get the total number of clicks on all of the authenticated user's bitly links" do
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/clicks.+$/, 'user_clicks.json')
      response = @user.total_clicks
      
      assert_kind_of Fixnum, response
    end
    
    should "be able to get entries from a user's link history" do
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/link_history.+$/, 'user_link_history.json')
      expected_keys = %w(aggregate_link archived client_id created_at link long_url modified_at private title user_ts)
      response = @user.link_history
      assert_kind_of Array, response 
      response.each do |entry|
        assert_kind_of Hash, entry
        assert_equal expected_keys.size, entry.keys.size
        assert (expected_keys - entry.keys).empty?
        entry.values.each{|value| assert_not_nil value}
      end
    end
    
    should "be able to get own info" do
      stub_get_json(/^https:\/\/api-ssl.bit.ly\/v3\/user\/info.+$/, 'user_info.json')
      response = @user.info
      assert_kind_of Hash, response
      assert response.values.all?{|value| !value.nil?}
    end
    
  end  
end

=begin  
    should "be able to get a basic access token" do      
      access_token = 'token123'
      api_key = 'key123'
      login = 'login123'
      FakeWeb.register_uri(
        :post, 
        'https://consumer_token:consumer_secret@api-ssl.bitly.com/oauth/access_token',
        :body => "access_token=#{access_token}&login=#{login}&apiKey=#{api_key}", 
        :content_type => "application/x-www-form-urlencoded"
      )
      
      oauth = Bitly::V3::OAuth.new('consumer_token', 'consumer_secret')
      oauth.get_basic_token
     
      assert_equal access_token, oauth.access_token.token
      assert_equal api_key, oauth.access_token.params['apiKey']
      assert_equal login, oauth.access_token.params['login']
    end
=end