require 'test_helper'

class TestBitlyError < Test::Unit::TestCase
  should "create a new bitly client" do
    res = mock(:status => 'code', :reason => 'message')
    error = BitlyError.new(res)
    assert_equal "message - 'code'", error.message
    assert_equal "message - 'code'", error.msg
    assert_equal "code", error.code
  end
end
