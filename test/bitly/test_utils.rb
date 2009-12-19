require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

class TestUtils < Test::Unit::TestCase
  include Bitly::Utils
  API_VERSION = '2.0.1'
  
  context "text utils" do
    should "underscore a word" do
      assert_equal "hello_world", underscore("HelloWorld")
    end
    should "create a hash from a bitly url" do
      assert_equal "hello", create_hash_from_url("http://bit.ly/hello")
    end
    should "create a hash from a jmp url" do
      assert_equal "hello", create_hash_from_url("http://j.mp/hello")
    end
  end
  
  context "class utils" do
    should "turn a key value pair into an instance variable" do
      attr_define('hello','goodbye')
      assert_equal @hello, "goodbye"
    end
    
    should "turn a hash into instance variables" do
      instance_variablise({'hello' => 'goodbye'}, ['hello'])
      assert_equal @hello, "goodbye"
    end
    
    should "not turn nonspecified variables into instance variables" do
      instance_variablise({'hello' => 'goodbye'}, [])
      assert_nil @hello
    end
  end
  
  context "creating a url" do
    setup do
      @api_key = api_key
      @login = login
    end
    should "contain all the basic information" do
      url = create_url.to_s
      assert url.include?('http://api.bit.ly/')
      assert url.include?("version=#{API_VERSION}")
      assert url.include?("apiKey=#{api_key}")
      assert url.include?("login=#{login}")
    end
    should "contain the right resource" do
      url = create_url('shorten').to_s
      assert url.include?('/shorten')
    end
    should "contain extra parameters" do
      url = create_url('shorten', :longUrl => 'http://google.com').to_s
      assert url.include?("longUrl=#{CGI.escape('http://google.com')}")
    end
  end
  
  context "fetching a url" do
    context "successfully" do
      setup do
        stub_get("http://example.com","cnn.json")
      end
      should "return a json object successfully" do
        result = get_result(URI.join("http://example.com"))
        assert_equal Hash, result.class
      end
    end
    context "unsuccessfully" do
      setup do
        stub_get("http://example.com", 'shorten_error.json')
      end
      should "raise BitlyError" do
        assert_raise BitlyError do
          result = get_result(URI.join("http://example.com"))
        end
      end
    end
  end
end