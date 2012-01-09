require 'test_helper'

class TestBase < Test::Unit::TestCase
  context "a request" do
    context "when successful" do
      setup do
        Bitly::Response.stubs(:new => stub('response', :success? => true, :body => {}))
        @strategy = Bitly::Strategy::Base.new
      end
      should "should proxy the request to run_request" do
        @strategy.expects(:run_request).once
        @strategy.request
      end
      should "should pass the args to run request" do
        @strategy.stubs(:run_request).with("these", "args")
        @strategy.request("these", "args")
      end
      should "return the body of the bitly response" do
        @strategy.stubs(:run_request => true)
        assert_equal @strategy.request, {}
      end
    end
    context "when unsuccessful" do
      should "raise a Bitly Error" do
        response = stub('response', :success? => false, :reason => "reason", :status => 500)
        Bitly::Response.stubs(:new => response)
        strategy = Bitly::Strategy::Base.new
        strategy.stubs(:run_request => true)
        assert_raise BitlyError do
          strategy.request
        end
      end
    end
  end
  context "run_request" do
    should "raise a Runtime Error" do
      strategy = Bitly::Strategy::Base.new
      assert_raise RuntimeError do
        strategy.send :run_request
      end
    end
  end
  context "validating a login and apiKey" do
    context "with valid login and apiKey" do
      setup do
        Bitly::Response.stubs(:new => stub('response', :success? => true, :body => {'valid' => 1}))
        @strategy = Bitly::Strategy::Base.new
        @strategy.expects(:run_request).once
      end
      should "return true when calling validate" do
        assert @strategy.validate(login_fixture, api_key_fixture)
      end
      should "return true when calling valid?" do
        assert @strategy.valid?(login_fixture, api_key_fixture)
      end
    end
    context "with an invalid login and apiKey" do
      setup do
        Bitly::Response.stubs(:new => stub('response', :success? => true, :body => {'valid' => 0}))
        @strategy = Bitly::Strategy::Base.new
        @strategy.expects(:run_request).once
      end
      should "return false when calling validate" do
        assert !@strategy.validate("bogus", "info")
      end
      should "return false when valling valid?" do
        assert !@strategy.valid?("bogus", "info")
      end
    end
  end
end
