require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestConfig < Test::Unit::TestCase
  context "bitly module" do
    should "create a new bitly v3 client through initializer" do
      # configure
      Bitly.configure do |config|  
        config.api_version = 3
        config.username = login
        config.api_key = api_key
      end
      b = Bitly.client
      assert_equal Bitly::V3::Client, b.class
    end
    
    should "create a new bitly v2 client through initializer" do
      # configure
      Bitly.configure do |config|  
        config.api_version = 2
        config.username = login
        config.api_key = api_key
      end
      b = Bitly.client
      assert_equal Bitly::Client, b.class
    end
  end  
end