module Bitly

  # The client is the main part of this gem. You need to initialize the client with your
  # username and API key and then you will be able to use the client to perform
  # all the rest of the actions available through the API.
  class Client
    extend Forwardable

    delegate [ :validate, :valid? ] => :strategy

    # Requires a Bitly::Strategy
    def initialize(strategy)
      raise ArgumentError, "Requires a Bitly::Strategy" unless strategy.is_a?(Bitly::Strategy::Base)

      @strategy = strategy
    end

    # Checks whether a domain is a bitly.Pro domain
    def bitly_pro_domain(domain)
      response = get(:bitly_pro_domain, :domain => domain)
      return response['bitly_pro_domain']
    end
    alias :pro? :bitly_pro_domain

    # Shortens a long url
    #
    # Options can be:
    #
    # [domain]                choose bit.ly or j.mp (bit.ly is default)
    #
    # [x_login and x_apiKey]  add this link to another user's history (both required)
    #
    def shorten(long_url, options={})
      response = get(:shorten, { :longUrl => long_url }.merge(options))
      return Bitly::Url.new(self, response)
    end

    # Expands either a hash, short url or array of either.
    #
    # Returns the results in the order they were entered
    def expand(input)
      get_method(:expand, input)
    end

    # Expands either a hash, short url or array of either and gets click data too.
    #
    # Returns the results in the order they were entered
    def clicks(input)
      get_method(:clicks, input)
    end

    # Like expand, but gets the title of the page and who created it
    def info(input)
      get_method(:info, input)
    end

    # Looks up the short url and global hash of a url or array of urls
    #
    # Returns the results in the order they were entered
    def lookup(input)
      input = input.to_a
      response = get(:lookup, :url => input)
      results = response['lookup'].inject([]) do |results, url|
        url['long_url'] = url.delete('url')
        if url['error'].nil?
          # builds the results array in the same order as the input
          results[input.index(url['long_url'])] = Bitly::Url.new(self, url)
        else
          results[input.index(url['long_url'])] = Bitly::MissingUrl.new(url)
        end
        # remove the key from the original array, in case the same hash/url was entered twice
        input[input.index(url['long_url'])] = nil
        results
      end
      return results.length > 1 ? results : results[0]
    end

    # Expands either a short link or hash and gets the referrer data for that link
    #
    # This method does not take an array as an input
    def referrers(input)
      get_single_method(:referrers, input)
    end

    # Expands either a short link or hash and gets the country data for that link
    #
    # This method does not take an array as an input
    def countries(input)
      get_single_method(:countries, input)
    end

    # Takes a short url, hash or array of either and gets the clicks by minute of each of the last hour
    def clicks_by_minute(input)
      get_method(:clicks_by_minute, input)
    end

    # Takes a short url, hash or array of either and gets the clicks by day
    def clicks_by_day(input, options={})
      options.reject! { |k, v| k.to_s != 'days' }
      get_method(:clicks_by_day, input, options)
    end

    private

    def strategy
      @strategy
    end

    def is_a_short_url?(input)
      input.match(/^http:\/\//)
    end

    def get_single_method(method, input)
      raise ArgumentError.new("This method only takes a hash or url input") unless input.is_a? String

      key = is_a_short_url?(input) ? :shortUrl : :hash

      response = get(method, key => input.to_a)
      return Bitly::Url.new(self, response)
    end

    def get_method(method, input, options={})
      options.symbolize_keys!
      input = input.to_a

      input.each do |i|
        key = is_a_short_url?(i) ? :shortUrl : :hash
        (options[key] ||= []) << i
      end

      response = get(method, options)

      results = response[method.to_s].inject([]) do |results, url|
        result_index = input.index(url['short_url'] || url['hash']) || input.index(url['global_hash'])

        if url['error'].nil?
          # builds the results array in the same order as the input
          results[result_index] = Bitly::Url.new(self, url)
        else
          results[result_index] = Bitly::MissingUrl.new(url)
        end
        # remove the key from the original array, in case the same hash/url was entered twice
        input[result_index] = nil
        results
      end
      return results.length > 1 ? results : results[0]
    end

    def get(method, options={})
      strategy.request(:get, method, options)
    end
  end
end
