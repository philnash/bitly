require 'test_helper'

class TestString < Test::Unit::TestCase
  context "Ruby String" do
    setup do
      @string = "string"
    end
    context "calling to_params" do
      should "return a string of key=value&" do
        assert_equal @string.to_a, [ @string ]
      end
    end
  end
end
