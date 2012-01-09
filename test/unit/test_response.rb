require 'test_helper'

class TestResponse < Test::Unit::TestCase
  context "with a unsupported response" do
    should "raise an error" do
      assert_raises RuntimeError, "Unsupported Response type: Object" do
        Bitly::Response.new(Object.new).success?
      end
    end
  end
  context "with an oauth response" do
    setup do
      OAuth2::Response.stubs(:=== => true)
    end
    should "return true" do
      response = Bitly::Response.new(stub('oauth', :parsed => {'status_code' => 200}))
      assert_equal true, response.success?
    end
    should "return false" do
      response = Bitly::Response.new(stub('oauth', :parsed => {'status_code' => 'not 200'}))
      assert_equal false, response.success?
    end
    should "return the status code" do
      response = Bitly::Response.new(stub('oauth', :parsed => {'status_code' => 'some status code'}))
      assert_equal 'some status code', response.status,
    end
    should "return the response body" do
      response = Bitly::Response.new(stub('oauth', :parsed => { 'data' => {} } ))
      assert_equal Hash.new, response.body
    end
    should "return the response body" do
      response = Bitly::Response.new(stub('oauth', :parsed => {'data' => nil}))
      assert_equal nil, response.body
    end
    should "return the status text reason" do
      response = Bitly::Response.new(stub('oauth', :parsed => {'status_txt' => "OK"}))
      assert_equal "OK", response.reason
    end
    should "return the status text reason" do
      response = Bitly::Response.new(stub('oauth', :parsed => {'status_txt' => "RATE_LIMIT_EXCEEDED"}))
      assert_equal "Rate Limit Exceeded", response.reason
    end
    should "return the status text reason" do
      response = Bitly::Response.new(stub('oauth', :parsed => {'status_txt' => "INVALID_ANYTHING"}))
      assert_equal "Invalid Anything", response.reason
    end
  end

  context "with a HTTParty response" do
    setup do
      HTTParty::Response.stubs(:=== => true)
    end
    should "return true" do
      response = Bitly::Response.new(stub(:parsed_response => { 'status_code' => 200 } ))
      assert_equal true, response.success?
    end
    should "return false" do
      response = Bitly::Response.new(stub(:parsed_response => { 'status_code' => 'not 200' }))
      assert_equal false, response.success?
    end
    should "return the status code" do
      response = Bitly::Response.new(stub(:parsed_response => { 'status_code' => 'some status code' }))
      assert_equal 'some status code', response.status,
    end
    should "return the response body" do
      response = Bitly::Response.new(stub(:parsed_response => { 'data' => {} } ))
      assert_equal Hash.new, response.body
    end
    should "return the response body" do
      response = Bitly::Response.new(stub(:parsed_response => { 'data' => nil }))
      assert_equal nil, response.body
    end
    should "return the status text reason" do
      response = Bitly::Response.new(stub(:parsed_response => { 'status_txt' => "OK" }))
      assert_equal "OK", response.reason
    end
    should "return the status text reason" do
      response = Bitly::Response.new(stub(:parsed_response => { 'status_txt' => "RATE_LIMIT_EXCEEDED" }))
      assert_equal "Rate Limit Exceeded", response.reason
    end
    should "return the status text reason" do
      response = Bitly::Response.new(stub(:parsed_response => { 'status_txt' => "INVALID_ANYTHING" }))
      assert_equal "Invalid Anything", response.reason
    end
  end
end
