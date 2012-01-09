require 'test_helper'

class TestUser < Test::Unit::TestCase
  context "with an access_token" do
    setup do
      consumer     = Bitly::Strategy::OAuth.new('consumer_token', 'consumer_secret')
      access_token = consumer.get_access_token_from_token('token')
      @user        = Bitly::User.new(access_token)
    end

    context 'referrers' do
      setup do
        stub_get(/https:\/\/api-ssl\.bit\.ly\/v3\/user\/referrers\?(access|oauth)_token=token/, 'user_referrers.json')
        @referrers = @user.referrers
      end

      should 'return an array of arrays of referrers' do
        assert_kind_of Array, @referrers
        assert_kind_of Array, @referrers.first
        assert_kind_of Bitly::Referrer, @referrers.first.first
      end

      should 'return data about the referrer' do
        referrer = @referrers.first.first
        assert_equal 'direct', referrer.referrer
        assert_equal 1, referrer.clicks
      end
    end

    context 'countries' do
      setup do
        stub_get(/https:\/\/api-ssl\.bit\.ly\/v3\/user\/countries\?(access|oauth)_token=token/, 'user_countries.json')
        @countries = @user.countries
      end

      should 'return an array of arrays of countries' do
        assert_kind_of Array, @countries
        assert_kind_of Array, @countries.first
        assert_kind_of Bitly::Country, @countries.first.first
      end

      should 'return data about the country' do
        country = @countries.first.first
        assert_equal "US", country.country
        assert_equal 4, country.clicks
      end
    end

    context 'clicks' do
      setup do
        stub_get(/https:\/\/api-ssl\.bit\.ly\/v3\/user\/clicks\?(access|oauth)_token=token/, 'user_clicks.json')
        @clicks = @user.clicks
      end

      should 'return an array of days' do
        assert_kind_of Array, @clicks
        assert_kind_of Bitly::Day, @clicks.first
      end

      should 'return data about the day' do
        day = @clicks.first
        assert_equal 4, day.clicks
      end

      should 'get total clicks' do
        assert_equal 29, @user.total_clicks
      end
    end

    context 'total clicks' do
      setup do
        stub_get(/https:\/\/api-ssl\.bit\.ly\/v3\/user\/clicks\?(access|oauth)_token=token/, 'user_clicks.json')
      end

      should 'get total clicks' do
        assert_equal 29, @user.total_clicks
      end
    end

    context 'realtime links' do
      setup do
        stub_get(/https:\/\/api-ssl\.bit\.ly\/v3\/user\/realtime_links\?(access|oauth)_token=token/, 'user_realtime_links.json')
        @realtime_links = @user.realtime_links
      end

      should 'get an array of realtime links' do
        assert_kind_of Array, @realtime_links
        assert_kind_of Bitly::RealtimeLink, @realtime_links.first
      end

      should 'get the data for the realtime links' do
        assert_equal 15, @realtime_links.first.clicks
        assert_equal "i7JWw0", @realtime_links.first.user_hash
      end
    end
  end
end
