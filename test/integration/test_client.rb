require 'test_helper'

class TestClient < Test::Unit::TestCase
  context "with a valid client" do
    context "with the ApiKey Strategy" do
      setup do
        @bitly = Bitly::Client.new Bitly::Strategy::ApiKey.new(login_fixture, api_key_fixture)
      end

      context "validating another account credentials" do
        context "with valid credentials" do
          setup do
            stub_get(%r{http://api\.bit\.ly/v3/validate?.*x_login=correct.*}, "valid_user.json")
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
            stub_get(%r{http://api\.bit\.ly/v3/validate?.*x_login=wrong.*},"invalid_user.json")
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

          should "return false" do
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

      context "shortening a url" do
        context "with just the url" do
          setup do
            @long_url = "http://betaworks.com/"
            stub_get(%r|http://api\.bit\.ly/v3/shorten\?.*longUrl=#{CGI.escape(@long_url)}.*|, ['betaworks.json', 'betaworks2.json'])
            @url = @bitly.shorten(@long_url)
          end

          should "return a url object" do
            assert_instance_of Bitly::Url, @url
          end

          should "shorten the url" do
            assert_equal 'http://bit.ly/9uX1TE', @url.short_url
          end

          should "return the original long url" do
            assert_equal @long_url, @url.long_url
          end

          should "return a hash" do
            assert_equal '9uX1TE', @url.user_hash
          end

          should "return a global hash" do
            assert_equal '18H1ET', @url.global_hash
          end

          should "be a new hash the first time" do
            assert @url.new_hash?
          end

          should "not be a new hash the second time" do
            new_url = @bitly.shorten(@long_url)
            assert !new_url.new_hash?
            assert_not_same @url, new_url
          end
        end

        context "with extra options" do
          context "with the j.mp domain" do
            setup do
              stub_get("http://api.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&apiKey=test_key&login=test_account&domain=j.mp", 'betaworks_jmp.json')
              @url = @bitly.shorten('http://betaworks.com/', :domain => "j.mp")
            end

            should "return a j.mp short url" do
              assert_equal "http://j.mp/9uX1TE", @url.short_url
            end
          end

          context "with another domain" do
            setup do
              stub_get("http://api.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&apiKey=test_key&login=test_account&domain=nyti.ms", 'invalid_domain.json')
            end

            should "raise an error" do
              assert_raise BitlyError do
                url = @bitly.shorten('http://betaworks.com/', :domain => "nyti.ms")
              end
            end
          end

          context "with another user details" do
            context "with correct details" do
              setup do
                @long_url = "http://betaworks.com/"
                stub_get(%r{http://api\.bit\.ly/v3/shorten?.*longUrl=#{CGI.escape('http://betaworks.com/')}.*}, 'betaworks.json')
                stub_get("http://api.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&apiKey=test_key&login=test_account&x_login=other_account&x_apiKey=other_apiKey", 'betaworks_other_user.json' )
                @normal_url = @bitly.shorten(@long_url)
                @other_user_url = @bitly.shorten(@long_url, :x_login => 'other_account', :x_apiKey => 'other_apiKey')
              end

              should "return a different hash" do
                assert_not_equal @normal_url.user_hash, @other_user_url.user_hash
              end

              should "return a new hash" do
                assert @other_user_url.new_hash?
              end
            end

            context "without an api key" do
              setup do
                stub_get("http://api.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&apiKey=test_key&login=test_account&x_login=other_account", 'invalid_x_api_key.json' )
              end

              should "raise an error" do
                assert_raise BitlyError do
                  @bitly.shorten('http://betaworks.com/', :x_login => 'other_account')
                end
              end
            end
          end
        end
      end

      context "expanding a url" do
        context "a single url" do
          context "with a hash" do
            setup do
              @hash = '9uX1TE'
              stub_get(%r|http://api\.bit\.ly/v3/expand\?.*hash=9uX1TE.*|, '9uX1TE.json')
              @url = @bitly.expand(@hash)
            end

            should 'return a url object' do
              assert_instance_of Bitly::Url, @url
            end

            should 'return the original hash' do
              assert_equal @hash, @url.user_hash
            end

            should "return a global hash" do
              assert_equal '18H1ET', @url.global_hash
            end

            should 'return a long url' do
              assert_equal 'http://betaworks.com/', @url.long_url
            end

            should 'return a short url' do
              assert_equal "http://bit.ly/#{@hash}", @url.short_url
            end
          end

          context "with the short url" do
            setup do
              @short_url = 'http://bit.ly/9uX1TE'
              stub_get(%r|http://api\.bit\.ly/v3/expand\?.*shortUrl=http%3A%2F%2Fbit\.ly%2F9uX1TE.*|, 'bitly9uX1TE.json')
              @url = @bitly.expand(@short_url)
            end

            should 'return a url object' do
              assert_instance_of Bitly::Url, @url
            end

            should 'return the original hash' do
              assert_equal "9uX1TE", @url.user_hash
            end

            should "return a global hash" do
              assert_equal '18H1ET', @url.global_hash
            end

            should 'return a long url' do
              assert_equal 'http://betaworks.com/', @url.long_url
            end

            should 'return a short url' do
              assert_equal "http://bit.ly/9uX1TE", @url.short_url
            end
          end

          context "that doesn't exist" do
            setup do
              @shortUrl = 'http://bit.ly/9uX1TEsd'
              stub_get(%r|http://api\.bit\.ly/v3/expand\?.*shortUrl=http%3A%2F%2Fbit\.ly%2F9uX1TEsd.*|, 'missing_hash.json')
              @url = @bitly.expand(@shortUrl)
            end
            should 'return a missing url' do
              assert_instance_of Bitly::MissingUrl, @url
            end
            should 'return an error' do
              assert_equal 'NOT_FOUND', @url.error
            end
            should 'return the original url' do
              assert_equal @shortUrl, @url.short_url
            end
          end
        end
        context "multiple urls" do
          setup do
            @hash = '9uX1TE'
            @short_url = 'http://bit.ly/cEFx9W'
            stub_get("http://api.bit.ly/v3/expand?hash=9uX1TE&shortUrl=http%3A%2F%2Fbit.ly%2FcEFx9W&login=test_account&apiKey=test_key", 'multiple_urls.json')
            @urls = @bitly.expand([@hash, @short_url])
          end
          should "return an array of results" do
            assert_instance_of Array, @urls
          end
          should "return an array of bitly urls" do
            @urls.each { |url| assert_instance_of Bitly::Url, url }
          end
          should "return the original url" do
            assert_equal 'http://betaworks.com/', @urls[0].long_url
            assert_equal 'http://philnash.co.uk', @urls[1].long_url
          end
        end
      end

      context "clicks for urls" do
        context "with multiple urls" do
          setup do
            @hash = '9uX1TE'
            @short_url = 'http://bit.ly/cEFx9W'
            stub_get("http://api.bit.ly/v3/clicks?hash=9uX1TE&shortUrl=http%3A%2F%2Fbit.ly%2FcEFx9W&login=test_account&apiKey=test_key", 'multiple_url_click.json')
            @urls = @bitly.clicks([@hash, @short_url])
          end

          should "return an array of results" do
            assert_instance_of Array, @urls
          end
          should "return an array of bitly urls" do
            @urls.each { |url| assert_instance_of Bitly::Url, url }
          end
          should "return the user and global clicks for each url" do
            assert_equal 0, @urls[0].user_clicks
            assert_equal 67, @urls[0].global_clicks
            assert_equal 0, @urls[1].user_clicks
            assert_equal 0, @urls[1].global_clicks
          end
        end
      end

      context "looking up" do
        context "a single url" do
          setup do
            @url = "http://code.google.com/p/bitly-api/"
            stub_get("http://api.bit.ly/v3/lookup?url=#{CGI.escape(@url)}&login=test_account&apiKey=test_key", 'lookup_single_url.json')
            @lookup = @bitly.lookup(@url)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @lookup
          end
          should "return the original url" do
            assert_equal @url, @lookup.long_url
          end
          should "return the global hash" do
            assert_equal '1oDCU', @lookup.global_hash
          end
          should 'return the short url' do
            assert_equal 'http://bit.ly/1oDCU', @lookup.short_url
          end
        end
        context "multiple urls" do
          setup do
            @url1 = 'http://betaworks.com/'
            @url2 = 'http://code.google.com/p/bitly-api/'
            stub_get("http://api.bit.ly/v3/lookup?url=#{CGI.escape(@url1)}&url=#{CGI.escape(@url2)}&login=test_account&apiKey=test_key", 'lookup_multiple_url.json')
            @lookup = @bitly.lookup([@url1, @url2])
          end
          should 'return an array' do
            assert_instance_of Array, @lookup
          end
          should 'return an array of urls' do
            @lookup.each { |url| assert_instance_of Bitly::Url, url }
          end
          should 'return the original urls in order' do
            assert_equal @url1, @lookup[0].long_url
            assert_equal @url2, @lookup[1].long_url
          end
          should 'return global hashes' do
            assert_equal 'aboutus', @lookup[0].global_hash
            assert_equal '1oDCU', @lookup[1].global_hash
          end
          should 'return short urls' do
            assert_equal 'http://bit.ly/aboutus', @lookup[0].short_url
            assert_equal 'http://bit.ly/1oDCU', @lookup[1].short_url
          end
        end
        context "a non existant url" do
          setup do
            @url = "asdf://www.google.com/not/a/real/link"
            stub_get("http://api.bit.ly/v3/lookup?url=#{CGI.escape(@url)}&login=test_account&apiKey=test_key", 'lookup_not_real_url.json')
            @lookup = @bitly.lookup(@url)
          end
          should 'return a missing url' do
            assert_instance_of Bitly::MissingUrl, @lookup
          end
          should 'return the original url' do
            assert_equal @url, @lookup.long_url
          end
          should 'return the error' do
            assert_equal 'NOT_FOUND', @lookup.error
          end
        end
      end

      context "info for urls" do
        context "a single url" do
          setup do
            @url = "http://bit.ly/1YKMfY"
            stub_get("http://api.bit.ly/v3/info?shortUrl=#{CGI.escape(@url)}&login=test_account&apiKey=test_key", "url_info.json")
            @info = @bitly.info(@url)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @info
          end
          should "return the original short url" do
            assert_equal @url, @info.short_url
          end
          should "return the global hash" do
            assert_equal '1YKMfY', @info.global_hash
          end
          should "return the user hash" do
            assert_equal '1YKMfY', @info.user_hash
          end
          should "return the creator" do
            assert_equal 'bitly', @info.created_by
          end
          should "return the title" do
            assert_equal 'betaworks', @info.title
          end
        end
        context "a single hash" do
          setup do
            @hash = "1YKMfY"
            stub_get("http://api.bit.ly/v3/info?hash=#{@hash}&login=test_account&apiKey=test_key", "url_info.json")
            @info = @bitly.info(@hash)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @info
          end
          should "return the original short url" do
            assert_equal "http://bit.ly/#{@hash}", @info.short_url
          end
          should "return the global hash" do
            assert_equal @hash, @info.global_hash
          end
          should "return the user hash" do
            assert_equal @hash, @info.user_hash
          end
          should "return the creator" do
            assert_equal 'bitly', @info.created_by
          end
          should "return the title" do
            assert_equal 'betaworks', @info.title
          end
        end
        context "multiple urls with urls and hashes" do
          setup do
            @url = 'http://bit.ly/1YKMfY'
            @hash = '9uX1TE'
            stub_get("http://api.bit.ly/v3/info?shortUrl=#{CGI.escape(@url)}&hash=#{@hash}&login=test_account&apiKey=test_key", "multiple_info.json")
            @infos = @bitly.info([@url, @hash])
          end
          should 'return an array' do
            assert_instance_of Array, @infos
          end
          should 'return an array of urls' do
            @infos.each { |url| assert_instance_of Bitly::Url, url }
          end
          should 'return the original urls in order' do
            assert_equal @url, @infos[0].short_url
            assert_equal @hash, @infos[1].user_hash
          end
          should 'return info for each' do
            assert_equal 'bitly', @infos[0].created_by
            assert_equal 'philnash', @infos[1].created_by
          end
        end
        context "a nonexistant url" do
          setup do
            @url = 'http://bit.ly/1YKMfYasb'
            stub_get("http://api.bit.ly/v3/info?shortUrl=#{CGI.escape(@url)}&login=test_account&apiKey=test_key", 'not_found_info.json')
            @info = @bitly.info(@url)
          end
          should "return a missing url" do
            assert_instance_of Bitly::MissingUrl, @info
          end
          should 'return the original url' do
            assert_equal @url, @info.short_url
          end
          should 'return the error' do
            assert_equal 'NOT_FOUND', @info.error
          end
        end
      end

      context "referrers for url" do
        context "a single url" do
          setup do
            @url = 'http://bit.ly/djZ9g4'
            stub_get("http://api.bit.ly/v3/referrers?shortUrl=#{CGI.escape(@url)}&login=test_account&apiKey=test_key", 'referrer_url.json')
            @bitly_url = @bitly.referrers(@url)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal @url, @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal 'djZ9g4', @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal 'djZ9g4', @bitly_url.user_hash
          end
          should 'return an array of referrers' do
            assert_instance_of Array, @bitly_url.referrers
          end
          should 'return a referrer' do
            assert_instance_of Bitly::Referrer, @bitly_url.referrers.first
          end
          should 'return the clicks and referrer from that url' do
            assert_equal 'direct', @bitly_url.referrers.first.referrer
            assert_equal 62, @bitly_url.referrers.first.clicks
          end
        end
        context "a single hash" do
          setup do
            @hash = 'djZ9g4'
            stub_get("http://api.bit.ly/v3/referrers?hash=#{CGI.escape(@hash)}&login=test_account&apiKey=test_key", 'referrer_url.json')
            @bitly_url = @bitly.referrers(@hash)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal "http://bit.ly/#{@hash}", @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal @hash, @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal @hash, @bitly_url.user_hash
          end
          should 'return an array of referrers' do
            assert_instance_of Array, @bitly_url.referrers
          end
          should 'return a referrer' do
            assert_instance_of Bitly::Referrer, @bitly_url.referrers.first
          end
          should 'return the clicks and referrer from that url' do
            assert_equal 'direct', @bitly_url.referrers.first.referrer
            assert_equal 62, @bitly_url.referrers.first.clicks
          end
        end

        context "an array" do
          should "raise an argument error" do
            assert_raises ArgumentError do
              @bitly.referrers(['http://bit.ly/djZ9g4'])
            end
          end
        end
      end

      context "countries for url" do
        context "a single url" do
          setup do
            @url = 'http://bit.ly/djZ9g4'
            stub_get("http://api.bit.ly/v3/countries?shortUrl=#{CGI.escape(@url)}&login=test_account&apiKey=test_key", 'country_url.json')
            @bitly_url = @bitly.countries(@url)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal @url, @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal 'djZ9g4', @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal 'djZ9g4', @bitly_url.user_hash
          end
          should 'return an array of countries' do
            assert_instance_of Array, @bitly_url.countries
          end
          should 'return a country' do
            assert_instance_of Bitly::Country, @bitly_url.countries.first
          end
          should 'return the clicks and country from that url' do
            assert_equal 'US', @bitly_url.countries.first.country
            assert_equal 58, @bitly_url.countries.first.clicks
          end
        end
        context "a single hash" do
          setup do
            @hash = 'djZ9g4'
            stub_get("http://api.bit.ly/v3/countries?hash=#{CGI.escape(@hash)}&login=test_account&apiKey=test_key", 'country_hash.json')
            @bitly_url = @bitly.countries(@hash)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal "http://bit.ly/#{@hash}", @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal @hash, @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal @hash, @bitly_url.user_hash
          end
          should 'return an array of countries' do
            assert_instance_of Array, @bitly_url.countries
          end
          should 'return a country' do
            assert_instance_of Bitly::Country, @bitly_url.countries.first
          end
          should 'return the clicks and country from that url' do
            assert_equal 'US', @bitly_url.countries.first.country
            assert_equal 58, @bitly_url.countries.first.clicks
          end
        end

        context "an array" do
          should "raise an argument error" do
            assert_raises ArgumentError do
              @bitly.countries(['http://bit.ly/djZ9g4'])
            end
          end
        end
      end

      context "clicks by minute for urls" do
        context "with a single short url" do
          setup do
            @short_url = "http://j.mp/9DguyN"
            stub_get("http://api.bit.ly/v3/clicks_by_minute?shortUrl=#{CGI.escape(@short_url)}&login=test_account&apiKey=test_key", 'clicks_by_minute1_url.json')
            @url = @bitly.clicks_by_minute(@short_url)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @url
          end
          should 'return the original hash' do
            assert_equal "9DguyN", @url.user_hash
          end
          should "return a global hash" do
            assert_equal '9DguyN', @url.global_hash
          end
          should 'return a short url' do
            assert_equal @short_url, @url.short_url
          end
          should 'return an array of clicks by minute' do
            assert_instance_of Array, @url.clicks_by_minute
            assert_equal 0, @url.clicks_by_minute[0]
            assert_equal 1, @url.clicks_by_minute[1]
          end
        end
        context "with a single hash" do
          setup do
            @hash = '9DguyN'
            stub_get("http://api.bit.ly/v3/clicks_by_minute?hash=#{@hash}&login=test_account&apiKey=test_key", 'clicks_by_minute_hash.json')
            @url = @bitly.clicks_by_minute(@hash)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @url
          end
          should 'return the original hash' do
            assert_equal "9DguyN", @url.user_hash
          end
          should "return a global hash" do
            assert_equal '9DguyN', @url.global_hash
          end
          should 'return an array of clicks by minute' do
            assert_instance_of Array, @url.clicks_by_minute
            assert_equal 0, @url.clicks_by_minute[0]
            assert_equal 1, @url.clicks_by_minute[6]
          end
        end
        context "with multiple hashes" do
          setup do
            @hash1 = '9DguyN'
            @hash2 = 'dvxi6W'
            @hashes = [@hash1, @hash2]
            stub_get("http://api.bit.ly/v3/clicks_by_minute?hash=#{@hash1}&hash=#{@hash2}&login=test_account&apiKey=test_key", 'clicks_by_minute_hashes.json')
            @urls = @bitly.clicks_by_minute(@hashes)
          end
          should 'return an array of urls' do
            assert_instance_of Array, @urls
            assert_instance_of Bitly::Url, @urls[0]
            assert_instance_of Bitly::Url, @urls[1]
          end
          should 'return the original hashes in order' do
            assert_equal @hash1, @urls[0].user_hash
            assert_equal @hash2, @urls[1].user_hash
          end
          should 'return arrays of clicks for each hash' do
            assert_instance_of Array, @urls[0].clicks_by_minute
            assert_instance_of Array, @urls[1].clicks_by_minute
          end
        end
      end

      context "clicks by day for urls" do
        setup do
          @hash1 = "9DguyN"
          @hash2 = "dvxi6W"
          @hashes = [@hash1, @hash2]
        end
        context "for multiple hashes" do
          setup do
            stub_get("http://api.bit.ly/v3/clicks_by_day?hash=9DguyN&hash=dvxi6W&login=test_account&apiKey=test_key", 'clicks_by_day.json')
            @urls = @bitly.clicks_by_day(@hashes)
          end
          should "return an array of urls" do
            assert_instance_of Array, @urls
            assert_instance_of Bitly::Url, @urls[0]
            assert_instance_of Bitly::Url, @urls[1]
          end
          should "return an array of days for each url" do
            assert_instance_of Array, @urls[0].clicks_by_day
            assert_instance_of Bitly::Day, @urls[0].clicks_by_day[0]
          end
          should "return a Time for the day" do
            assert_instance_of Time, @urls[0].clicks_by_day[0].day_start
            assert_equal Time.parse('2010/11/23'), @urls[0].clicks_by_day[0].day_start
          end
          should 'return the number of clicks for that day' do
            assert_equal 1, @urls[0].clicks_by_day[0].clicks
          end
        end
        context "with optional days parameter" do
          should 'add days to url' do
            stub_get("http://api.bit.ly/v3/clicks_by_day?hash=9DguyN&hash=dvxi6W&login=test_account&apiKey=test_key&days=30", 'clicks_by_day.json')
            @urls = @bitly.clicks_by_day(@hashes, :days => 30)
          end

          should 'not add other parameters' do
            stub_get("http://api.bit.ly/v3/clicks_by_day?hash=9DguyN&hash=dvxi6W&login=test_account&apiKey=test_key&days=30", 'clicks_by_day.json')
            @urls = @bitly.clicks_by_day(@hashes, :days => 30, :something_else => 'bacon')
          end
        end
      end
    end

    context "without valid credentials" do
      setup do
        @bitly = Bitly::Client.new(Bitly::Strategy::ApiKey.new('rubbish', 'wrong'))
        stub_get(%r|http://api\.bit\.ly/v3/shorten?.*|, 'invalid_credentials.json')
      end
      should "raise an error on any call" do
        assert_raise BitlyError do
          @bitly.shorten('http://google.com')
        end
      end
    end
  end

  context "with a valid client" do
    context "with the OAuth Strategy" do
      setup do
        strategy = Bitly::Strategy::OAuth.new("id", "secret")
        strategy.set_access_token_from_token!('token')
        @bitly = Bitly::Client.new(strategy)
      end

      context "validating another account credentials" do
        context "with valid credentials" do
          setup do
            stub_get(%r{https://api-ssl\.bit\.ly/v3/validate?.*x_login=correct.*}, "valid_user.json")
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
            stub_get(%r{https://api-ssl\.bit\.ly/v3/validate?.*x_login=wrong.*},"invalid_user.json")
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
            stub_get(%r|https://api-ssl\.bit\.ly/v3/bitly_pro_domain?.*domain=nyti\.ms.*|, 'bitly_pro_domain.json')
          end

          should "return true" do
            assert @bitly.bitly_pro_domain('nyti.ms')
          end
        end

        context "with a non bitly pro domain" do
          setup do
            stub_get(%r|https://api-ssl\.bit\.ly/v3/bitly_pro_domain?.*domain=philnash\.co\.uk.*|, 'not_bitly_pro_domain.json')
          end

          should "return false" do
            assert !@bitly.bitly_pro_domain('philnash.co.uk')
          end
        end

        context "with an invalid domain" do
          setup do
            stub_get(%r|https://api-ssl\.bit\.ly/v3/bitly_pro_domain?.*domain=philnash.*|, 'invalid_bitly_pro_domain.json')
          end

          should "raise an error" do
            assert_raise BitlyError do
              @bitly.bitly_pro_domain('philnash')
            end
          end
        end
      end

      context "shortening a url" do
        context "with just the url" do
          setup do
            @long_url = "http://betaworks.com/"
            stub_get(%r|https://api-ssl\.bit\.ly/v3/shorten\?.*longUrl=#{CGI.escape(@long_url)}.*|, ['betaworks.json', 'betaworks2.json'])
            @url = @bitly.shorten(@long_url)
          end

          should "return a url object" do
            assert_instance_of Bitly::Url, @url
          end

          should "shorten the url" do
            assert_equal 'http://bit.ly/9uX1TE', @url.short_url
          end

          should "return the original long url" do
            assert_equal @long_url, @url.long_url
          end

          should "return a hash" do
            assert_equal '9uX1TE', @url.user_hash
          end

          should "return a global hash" do
            assert_equal '18H1ET', @url.global_hash
          end

          should "be a new hash the first time" do
            assert @url.new_hash?
          end

          should "not be a new hash the second time" do
            new_url = @bitly.shorten(@long_url)
            assert !new_url.new_hash?
            assert_not_same @url, new_url
          end
        end

        context "with extra options" do
          context "with the j.mp domain" do
            setup do
              stub_get("https://api-ssl.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&access_token=token&domain=j.mp", 'betaworks_jmp.json')
              @url = @bitly.shorten('http://betaworks.com/', :domain => "j.mp")
            end

            should "return a j.mp short url" do
              assert_equal "http://j.mp/9uX1TE", @url.short_url
            end
          end

          context "with another domain" do
            setup do
              stub_get("https://api-ssl.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&access_token=token&domain=nyti.ms", 'invalid_domain.json')
            end

            should "raise an error" do
              assert_raise BitlyError do
                url = @bitly.shorten('http://betaworks.com/', :domain => "nyti.ms")
              end
            end
          end

          context "with another user details" do
            context "with correct details" do
              setup do
                @long_url = "http://betaworks.com/"
                stub_get(%r{https://api-ssl\.bit\.ly/v3/shorten?.*longUrl=#{CGI.escape('http://betaworks.com/')}.*}, 'betaworks.json')
                stub_get("https://api-ssl.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&access_token=token&x_login=other_account&x_apiKey=other_apiKey", 'betaworks_other_user.json' )
                @normal_url = @bitly.shorten(@long_url)
                @other_user_url = @bitly.shorten(@long_url, :x_login => 'other_account', :x_apiKey => 'other_apiKey')
              end

              should "return a different hash" do
                assert_not_equal @normal_url.user_hash, @other_user_url.user_hash
              end

              should "return a new hash" do
                assert @other_user_url.new_hash?
              end
            end

            context "without an api key" do
              setup do
                stub_get("https://api-ssl.bit.ly/v3/shorten?longUrl=#{CGI.escape('http://betaworks.com/')}&access_token=token&x_login=other_account", 'invalid_x_api_key.json' )
              end

              should "raise an error" do
                assert_raise BitlyError do
                  @bitly.shorten('http://betaworks.com/', :x_login => 'other_account')
                end
              end
            end
          end
        end
      end

      context "expanding a url" do
        context "a single url" do
          context "with a hash" do
            setup do
              @hash = '9uX1TE'
              stub_get(%r|https://api-ssl\.bit\.ly/v3/expand\?.*hash=9uX1TE.*|, '9uX1TE.json')
              @url = @bitly.expand(@hash)
            end

            should 'return a url object' do
              assert_instance_of Bitly::Url, @url
            end

            should 'return the original hash' do
              assert_equal @hash, @url.user_hash
            end

            should "return a global hash" do
              assert_equal '18H1ET', @url.global_hash
            end

            should 'return a long url' do
              assert_equal 'http://betaworks.com/', @url.long_url
            end

            should 'return a short url' do
              assert_equal "http://bit.ly/#{@hash}", @url.short_url
            end
          end

          context "with the short url" do
            setup do
              @short_url = 'http://bit.ly/9uX1TE'
              stub_get(%r|https://api-ssl\.bit\.ly/v3/expand\?.*shortUrl=http%3A%2F%2Fbit\.ly%2F9uX1TE.*|, 'bitly9uX1TE.json')
              @url = @bitly.expand(@short_url)
            end

            should 'return a url object' do
              assert_instance_of Bitly::Url, @url
            end

            should 'return the original hash' do
              assert_equal "9uX1TE", @url.user_hash
            end

            should "return a global hash" do
              assert_equal '18H1ET', @url.global_hash
            end

            should 'return a long url' do
              assert_equal 'http://betaworks.com/', @url.long_url
            end

            should 'return a short url' do
              assert_equal "http://bit.ly/9uX1TE", @url.short_url
            end
          end

          context "that doesn't exist" do
            setup do
              @shortUrl = 'http://bit.ly/9uX1TEsd'
              stub_get(%r|https://api-ssl\.bit\.ly/v3/expand\?.*shortUrl=http%3A%2F%2Fbit\.ly%2F9uX1TEsd.*|, 'missing_hash.json')
              @url = @bitly.expand(@shortUrl)
            end
            should 'return a missing url' do
              assert_instance_of Bitly::MissingUrl, @url
            end
            should 'return an error' do
              assert_equal 'NOT_FOUND', @url.error
            end
            should 'return the original url' do
              assert_equal @shortUrl, @url.short_url
            end
          end
        end
        context "multiple urls" do
          setup do
            @hash = '9uX1TE'
            @short_url = 'http://bit.ly/cEFx9W'
            stub_get("https://api-ssl.bit.ly/v3/expand?hash=9uX1TE&shortUrl=http%3A%2F%2Fbit.ly%2FcEFx9W&access_token=token", 'multiple_urls.json')
            @urls = @bitly.expand([@hash, @short_url])
          end
          should "return an array of results" do
            assert_instance_of Array, @urls
          end
          should "return an array of bitly urls" do
            @urls.each { |url| assert_instance_of Bitly::Url, url }
          end
          should "return the original url" do
            assert_equal 'http://betaworks.com/', @urls[0].long_url
            assert_equal 'http://philnash.co.uk', @urls[1].long_url
          end
        end
      end

      context "clicks for urls" do
        context "with multiple urls" do
          setup do
            @hash = '9uX1TE'
            @short_url = 'http://bit.ly/cEFx9W'
            stub_get("https://api-ssl.bit.ly/v3/clicks?hash=9uX1TE&shortUrl=http%3A%2F%2Fbit.ly%2FcEFx9W&access_token=token", 'multiple_url_click.json')
            @urls = @bitly.clicks([@hash, @short_url])
          end

          should "return an array of results" do
            assert_instance_of Array, @urls
          end
          should "return an array of bitly urls" do
            @urls.each { |url| assert_instance_of Bitly::Url, url }
          end
          should "return the user and global clicks for each url" do
            assert_equal 0, @urls[0].user_clicks
            assert_equal 67, @urls[0].global_clicks
            assert_equal 0, @urls[1].user_clicks
            assert_equal 0, @urls[1].global_clicks
          end
        end
      end

      context "looking up" do
        context "a single url" do
          setup do
            @url = "http://code.google.com/p/bitly-api/"
            stub_get("https://api-ssl.bit.ly/v3/lookup?url=#{CGI.escape(@url)}&access_token=token", 'lookup_single_url.json')
            @lookup = @bitly.lookup(@url)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @lookup
          end
          should "return the original url" do
            assert_equal @url, @lookup.long_url
          end
          should "return the global hash" do
            assert_equal '1oDCU', @lookup.global_hash
          end
          should 'return the short url' do
            assert_equal 'http://bit.ly/1oDCU', @lookup.short_url
          end
        end
        context "multiple urls" do
          setup do
            @url1 = 'http://betaworks.com/'
            @url2 = 'http://code.google.com/p/bitly-api/'
            stub_get("https://api-ssl.bit.ly/v3/lookup?url=#{CGI.escape(@url1)}&url=#{CGI.escape(@url2)}&access_token=token", 'lookup_multiple_url.json')
            @lookup = @bitly.lookup([@url1, @url2])
          end
          should 'return an array' do
            assert_instance_of Array, @lookup
          end
          should 'return an array of urls' do
            @lookup.each { |url| assert_instance_of Bitly::Url, url }
          end
          should 'return the original urls in order' do
            assert_equal @url1, @lookup[0].long_url
            assert_equal @url2, @lookup[1].long_url
          end
          should 'return global hashes' do
            assert_equal 'aboutus', @lookup[0].global_hash
            assert_equal '1oDCU', @lookup[1].global_hash
          end
          should 'return short urls' do
            assert_equal 'http://bit.ly/aboutus', @lookup[0].short_url
            assert_equal 'http://bit.ly/1oDCU', @lookup[1].short_url
          end
        end
        context "a non existant url" do
          setup do
            @url = "asdf://www.google.com/not/a/real/link"
            stub_get("https://api-ssl.bit.ly/v3/lookup?url=#{CGI.escape(@url)}&access_token=token", 'lookup_not_real_url.json')
            @lookup = @bitly.lookup(@url)
          end
          should 'return a missing url' do
            assert_instance_of Bitly::MissingUrl, @lookup
          end
          should 'return the original url' do
            assert_equal @url, @lookup.long_url
          end
          should 'return the error' do
            assert_equal 'NOT_FOUND', @lookup.error
          end
        end
      end

      context "info for urls" do
        context "a single url" do
          setup do
            @url = "http://bit.ly/1YKMfY"
            stub_get("https://api-ssl.bit.ly/v3/info?shortUrl=#{CGI.escape(@url)}&access_token=token", "url_info.json")
            @info = @bitly.info(@url)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @info
          end
          should "return the original short url" do
            assert_equal @url, @info.short_url
          end
          should "return the global hash" do
            assert_equal '1YKMfY', @info.global_hash
          end
          should "return the user hash" do
            assert_equal '1YKMfY', @info.user_hash
          end
          should "return the creator" do
            assert_equal 'bitly', @info.created_by
          end
          should "return the title" do
            assert_equal 'betaworks', @info.title
          end
        end
        context "a single hash" do
          setup do
            @hash = "1YKMfY"
            stub_get("https://api-ssl.bit.ly/v3/info?hash=#{@hash}&access_token=token", "url_info.json")
            @info = @bitly.info(@hash)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @info
          end
          should "return the original short url" do
            assert_equal "http://bit.ly/#{@hash}", @info.short_url
          end
          should "return the global hash" do
            assert_equal @hash, @info.global_hash
          end
          should "return the user hash" do
            assert_equal @hash, @info.user_hash
          end
          should "return the creator" do
            assert_equal 'bitly', @info.created_by
          end
          should "return the title" do
            assert_equal 'betaworks', @info.title
          end
        end
        context "multiple urls with urls and hashes" do
          setup do
            @url = 'http://bit.ly/1YKMfY'
            @hash = '9uX1TE'
            stub_get("https://api-ssl.bit.ly/v3/info?shortUrl=#{CGI.escape(@url)}&hash=#{@hash}&access_token=token", "multiple_info.json")
            @infos = @bitly.info([@url, @hash])
          end
          should 'return an array' do
            assert_instance_of Array, @infos
          end
          should 'return an array of urls' do
            @infos.each { |url| assert_instance_of Bitly::Url, url }
          end
          should 'return the original urls in order' do
            assert_equal @url, @infos[0].short_url
            assert_equal @hash, @infos[1].user_hash
          end
          should 'return info for each' do
            assert_equal 'bitly', @infos[0].created_by
            assert_equal 'philnash', @infos[1].created_by
          end
        end
        context "a nonexistant url" do
          setup do
            @url = 'http://bit.ly/1YKMfYasb'
            stub_get("https://api-ssl.bit.ly/v3/info?shortUrl=#{CGI.escape(@url)}&access_token=token", 'not_found_info.json')
            @info = @bitly.info(@url)
          end
          should "return a missing url" do
            assert_instance_of Bitly::MissingUrl, @info
          end
          should 'return the original url' do
            assert_equal @url, @info.short_url
          end
          should 'return the error' do
            assert_equal 'NOT_FOUND', @info.error
          end
        end
      end

      context "referrers for url" do
        context "a single url" do
          setup do
            @url = 'http://bit.ly/djZ9g4'
            stub_get("https://api-ssl.bit.ly/v3/referrers?shortUrl=#{CGI.escape(@url)}&access_token=token", 'referrer_url.json')
            @bitly_url = @bitly.referrers(@url)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal @url, @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal 'djZ9g4', @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal 'djZ9g4', @bitly_url.user_hash
          end
          should 'return an array of referrers' do
            assert_instance_of Array, @bitly_url.referrers
          end
          should 'return a referrer' do
            assert_instance_of Bitly::Referrer, @bitly_url.referrers.first
          end
          should 'return the clicks and referrer from that url' do
            assert_equal 'direct', @bitly_url.referrers.first.referrer
            assert_equal 62, @bitly_url.referrers.first.clicks
          end
        end
        context "a single hash" do
          setup do
            @hash = 'djZ9g4'
            stub_get("https://api-ssl.bit.ly/v3/referrers?hash=#{CGI.escape(@hash)}&access_token=token", 'referrer_url.json')
            @bitly_url = @bitly.referrers(@hash)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal "http://bit.ly/#{@hash}", @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal @hash, @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal @hash, @bitly_url.user_hash
          end
          should 'return an array of referrers' do
            assert_instance_of Array, @bitly_url.referrers
          end
          should 'return a referrer' do
            assert_instance_of Bitly::Referrer, @bitly_url.referrers.first
          end
          should 'return the clicks and referrer from that url' do
            assert_equal 'direct', @bitly_url.referrers.first.referrer
            assert_equal 62, @bitly_url.referrers.first.clicks
          end
        end

        context "an array" do
          should "raise an argument error" do
            assert_raises ArgumentError do
              @bitly.referrers(['http://bit.ly/djZ9g4'])
            end
          end
        end
      end

      context "countries for url" do
        context "a single url" do
          setup do
            @url = 'http://bit.ly/djZ9g4'
            stub_get("https://api-ssl.bit.ly/v3/countries?shortUrl=#{CGI.escape(@url)}&access_token=token", 'country_url.json')
            @bitly_url = @bitly.countries(@url)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal @url, @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal 'djZ9g4', @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal 'djZ9g4', @bitly_url.user_hash
          end
          should 'return an array of countries' do
            assert_instance_of Array, @bitly_url.countries
          end
          should 'return a country' do
            assert_instance_of Bitly::Country, @bitly_url.countries.first
          end
          should 'return the clicks and country from that url' do
            assert_equal 'US', @bitly_url.countries.first.country
            assert_equal 58, @bitly_url.countries.first.clicks
          end
        end
        context "a single hash" do
          setup do
            @hash = 'djZ9g4'
            stub_get("https://api-ssl.bit.ly/v3/countries?hash=#{CGI.escape(@hash)}&access_token=token", 'country_hash.json')
            @bitly_url = @bitly.countries(@hash)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @bitly_url
          end
          should 'return the original short url' do
            assert_equal "http://bit.ly/#{@hash}", @bitly_url.short_url
          end
          should 'return the global hash' do
            assert_equal @hash, @bitly_url.global_hash
          end
          should 'return the user hash' do
            assert_equal @hash, @bitly_url.user_hash
          end
          should 'return an array of countries' do
            assert_instance_of Array, @bitly_url.countries
          end
          should 'return a country' do
            assert_instance_of Bitly::Country, @bitly_url.countries.first
          end
          should 'return the clicks and country from that url' do
            assert_equal 'US', @bitly_url.countries.first.country
            assert_equal 58, @bitly_url.countries.first.clicks
          end
        end

        context "an array" do
          should "raise an argument error" do
            assert_raises ArgumentError do
              @bitly.countries(['http://bit.ly/djZ9g4'])
            end
          end
        end
      end

      context "clicks by minute for urls" do
        context "with a single short url" do
          setup do
            @short_url = "http://j.mp/9DguyN"
            stub_get("https://api-ssl.bit.ly/v3/clicks_by_minute?shortUrl=#{CGI.escape(@short_url)}&access_token=token", 'clicks_by_minute1_url.json')
            @url = @bitly.clicks_by_minute(@short_url)
          end
          should "return a url object" do
            assert_instance_of Bitly::Url, @url
          end
          should 'return the original hash' do
            assert_equal "9DguyN", @url.user_hash
          end
          should "return a global hash" do
            assert_equal '9DguyN', @url.global_hash
          end
          should 'return a short url' do
            assert_equal @short_url, @url.short_url
          end
          should 'return an array of clicks by minute' do
            assert_instance_of Array, @url.clicks_by_minute
            assert_equal 0, @url.clicks_by_minute[0]
            assert_equal 1, @url.clicks_by_minute[1]
          end
        end
        context "with a single hash" do
          setup do
            @hash = '9DguyN'
            stub_get("https://api-ssl.bit.ly/v3/clicks_by_minute?hash=#{@hash}&access_token=token", 'clicks_by_minute_hash.json')
            @url = @bitly.clicks_by_minute(@hash)
          end
          should 'return a url object' do
            assert_instance_of Bitly::Url, @url
          end
          should 'return the original hash' do
            assert_equal "9DguyN", @url.user_hash
          end
          should "return a global hash" do
            assert_equal '9DguyN', @url.global_hash
          end
          should 'return an array of clicks by minute' do
            assert_instance_of Array, @url.clicks_by_minute
            assert_equal 0, @url.clicks_by_minute[0]
            assert_equal 1, @url.clicks_by_minute[6]
          end
        end
        context "with multiple hashes" do
          setup do
            @hash1 = '9DguyN'
            @hash2 = 'dvxi6W'
            @hashes = [@hash1, @hash2]
            stub_get("https://api-ssl.bit.ly/v3/clicks_by_minute?hash=#{@hash1}&hash=#{@hash2}&access_token=token", 'clicks_by_minute_hashes.json')
            @urls = @bitly.clicks_by_minute(@hashes)
          end
          should 'return an array of urls' do
            assert_instance_of Array, @urls
            assert_instance_of Bitly::Url, @urls[0]
            assert_instance_of Bitly::Url, @urls[1]
          end
          should 'return the original hashes in order' do
            assert_equal @hash1, @urls[0].user_hash
            assert_equal @hash2, @urls[1].user_hash
          end
          should 'return arrays of clicks for each hash' do
            assert_instance_of Array, @urls[0].clicks_by_minute
            assert_instance_of Array, @urls[1].clicks_by_minute
          end
        end
      end

      context "clicks by day for urls" do
        setup do
          @hash1 = "9DguyN"
          @hash2 = "dvxi6W"
          @hashes = [@hash1, @hash2]
        end
        context "for multiple hashes" do
          setup do
            stub_get("https://api-ssl.bit.ly/v3/clicks_by_day?hash=9DguyN&hash=dvxi6W&access_token=token", 'clicks_by_day.json')
            @urls = @bitly.clicks_by_day(@hashes)
          end
          should "return an array of urls" do
            assert_instance_of Array, @urls
            assert_instance_of Bitly::Url, @urls[0]
            assert_instance_of Bitly::Url, @urls[1]
          end
          should "return an array of days for each url" do
            assert_instance_of Array, @urls[0].clicks_by_day
            assert_instance_of Bitly::Day, @urls[0].clicks_by_day[0]
          end
          should "return a Time for the day" do
            assert_instance_of Time, @urls[0].clicks_by_day[0].day_start
            assert_equal Time.parse('2010/11/23'), @urls[0].clicks_by_day[0].day_start
          end
          should 'return the number of clicks for that day' do
            assert_equal 1, @urls[0].clicks_by_day[0].clicks
          end
        end
        context "with optional days parameter" do
          should 'add days to url' do
            stub_get("https://api-ssl.bit.ly/v3/clicks_by_day?hash=9DguyN&hash=dvxi6W&access_token=token&days=30", 'clicks_by_day.json')
            @urls = @bitly.clicks_by_day(@hashes, :days => 30)
          end

          should 'not add other parameters' do
            stub_get("https://api-ssl.bit.ly/v3/clicks_by_day?hash=9DguyN&hash=dvxi6W&access_token=token&days=30", 'clicks_by_day.json')
            @urls = @bitly.clicks_by_day(@hashes, :days => 30, :something_else => 'bacon')
          end
        end
      end
    end

    context "without valid credentials" do
      setup do
        strategy = Bitly::Strategy::OAuth.new('rubbish', 'wrong')
        strategy.set_access_token_from_token!('lies')
        @bitly = Bitly::Client.new(strategy)
        stub_get(%r|https://api-ssl\.bit\.ly/v3/shorten?.*|, 'invalid_credentials.json')
      end
      should "raise an error on any call" do
        assert_raise BitlyError do
          @bitly.shorten('http://google.com')
        end
      end
    end
  end
end
