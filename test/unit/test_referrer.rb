require 'test_helper'

class TestReferrer < Test::Unit::TestCase
  context "a referrer" do
    setup do
      @referrer = Bitly::Referrer.new({})
    end

    [:clicks, :referrer, :referrer_app, :url].each do |method|
      should "respond to #{method}" do
        assert_respond_to @referrer, method
      end

      should "set #{method} when initializing" do
        referrer = Bitly::Referrer.new(method.to_s => 'test')
        assert_equal 'test', referrer.send(method)
      end
    end
  end
end
