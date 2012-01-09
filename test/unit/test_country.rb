require 'test_helper'

class TestCountry < Test::Unit::TestCase
  context "a country" do
    setup do
      @country = Bitly::Country.new
    end

    [:clicks, :country].each do |method|
      should "respond to #{method}" do
        assert_respond_to @country, method
      end

      should "set #{method} when initializing" do
        country = Bitly::Country.new(method.to_s => 'test')
        assert_equal 'test', country.send(method)
      end
    end
  end
end
