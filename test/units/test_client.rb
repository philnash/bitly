require 'test_helper'

class TestClient < Test::Unit::TestCase
  context "creating a new client" do
    should "initialize with login and api key" do
      client = Bitly::Client.new(login, api_key)
      assert_equal login, client.login
      assert_equal api_key, client.api_key
    end
  end
  
  context "with a client" do
    setup do
      @bitly = Bitly::Client.new(login, api_key)
    end
    
    context "validating another account credentials" do
      context "with valid credentials" do
        setup do
          stub_get(%r|http://api\.bit\.ly/v3/validate?.*x_login=correct.*|, "valid_user.json")
        end
        should "return true" do
          assert @bitly.validate('correct','well_done')
        end
        should "return true for valid? as well" do
          assert @bitly.valid?('correct','well_done')
        end
      end
      context "with invalid credentials" do
        setup do
          stub_get(%r|http://api\.bit\.ly/v3/validate?.*x_login=wrong.*|,"invalid_user.json")
        end
        should "return false" do
          assert !@bitly.validate('wrong','so_very_wrong')
        end
        should "return false for valid? too" do
          assert !@bitly.valid?('wrong','so_very_wrong')
        end
      end
    end
    
    context "checking a bitly pro domain" do
      context "with a bitly pro domain" do
        setup do
          stub_get(%r|http://api\.bit\.ly/v3/bitly_pro_domain?.*domain=nyti\.ms.*|, 'bitly_pro_domain.json')
        end
        should "return true" do
          assert @bitly.bitly_pro_domain('nyti.ms')
        end
      end
      context "with a non bitly pro domain" do
        setup do
          stub_get(%r|http://api\.bit\.ly/v3/bitly_pro_domain?.*domain=philnash\.co\.uk.*|, 'not_bitly_pro_domain.json')
        end
        should "return true" do
          assert !@bitly.bitly_pro_domain('philnash.co.uk')
        end
      end
      context "with an invalid domain" do
        setup do
          stub_get(%r|http://api\.bit\.ly/v3/bitly_pro_domain?.*domain=philnash.*|, 'invalid_bitly_pro_domain.json')
        end
        should "raise an error" do
          assert_raise BitlyError do
            @bitly.bitly_pro_domain('philnash')
          end
        end
      end
    end
    
  end
end
