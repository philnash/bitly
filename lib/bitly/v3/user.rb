module Bitly
  module V3
    # A user requires an oauth access token. The flow is as follows:
    #
    #     o = Bitly::V3::OAuth.new(consumer_token, consumer_secret)
    #     o.authorize_url(redirect_url)
    #     #=> "https://bit.ly/oauth/authorize?client_id=#{consumer_token}&type=web_server&redirect_uri=http%3A%2F%2Ftest.local%2Fbitly%2Fauth"
    # Redirect your users to this url, when they authorize your application
    # they will be redirected to the url you provided with a code parameter.
    # Use that parameter, and the exact same redirect url as follows:
    #
    #     o.get_access_token_from_code(params[:code], redirect_url)
    #     #=> #<OAuth2::AccessToken ...>
    #
    # Then use that access token to create your user object.
    #
    #    u=Bitly::V3::User.new(o.access_token)
    class User
      include HTTParty
      base_uri 'https://api-ssl.bit.ly/v3/'
      attr_accessor :login, :api_key

      def initialize(access_token)
        @access_token = access_token
        @login = access_token['login'] || access_token['username']
        @api_key = access_token['apiKey'] || access_token['api_key']
      end           
      
      def info(opts={})
        return get_request("/user/info", opts){|data| data}        
      end
      
      # Edit link metadata. See http://dev.bitly.com/links.html#v3_user_link_edit
      def link_edit(link, opts)
        return get_request(
          "/user/link_edit", 
          opts.merge(:edit => opts.keys.join(','), :link => link),
        ){|data| data['link_edit']['link']}
      end
      
      # This is used to query for a bitly link shortened by the authenticated user based on a long URL
      # See http://dev.bitly.com/links.html#v3_user_link_lookup
      def link_lookup(url)
        return get_request(
          "/user/link_lookup", 
          :url => url
        ){|data| data['link_lookup'].first}                
      end
      
      # Returns aggregate metrics about the pages referring click traffic to all of the 
      # authenticated user's bitly links
      # http://dev.bitly.com/user_metrics.html#v3_user_referrers
      def referrers(opts={})
        if @referrers.nil? || opts.delete(:force)
          @referrers = get_method(:referrers, Bitly::V3::Referrer, opts)
        end
        @referrers
      end

      # Returns aggregate metrics about the countries referring click traffic to all 
      # of the authenticated user's bitly links
      #
      # http://dev.bitly.com/user_metrics.html#v3_user_countries
      def countries(opts={})
        if @countries.nil? || opts.delete(:force)
          @countries = get_method(:countries, Bitly::V3::Country, opts)
        end
        @countries
      end

      # Returns the authenticated user's most-clicked bitly links in a given time period
      #
      # http://dev.bitly.com/user_metrics.html#v3_user_popular_links
      def popular_links(opts={})
        if @realtime_links.nil? || opts.delete(:force)
          get_request("/user/popular_links", opts){|data|
            @realtime_links = data['popular_links'].map { |rs| Bitly::V3::PopularLink.new(rs) }
          }
        end
        @realtime_links
      end
      alias_method :realtime_links, :popular_links
      
      # Returns the aggregate number of clicks on all of the authenticated user's bitly links
      #
      # http://dev.bitly.com/user_metrics.html#v3_user_clicks
      def clicks(opts={})
        get_clicks(opts)
        @clicks
      end

      # Displays the total clicks returned from the clicks method.
      def total_clicks(opts={})
        get_clicks(opts)
        @total_clicks
      end

      # Returns a Bitly Client using the credentials of the user.
      def client
        @client ||= Bitly::V3::Client.new(login, api_key)
      end

      # Returns entries from a user's link history in reverse chronological order
      #
      # See http://dev.bitly.com/user_info.html#v3_user_link_history
      def link_history(opts={})
        return get_request(
          "/user/link_history", 
          opts
        ){|data| data['link_history']}
      end

      private
      
      def get_request(path, opts={})
        opts.merge!(:access_token => @access_token.token)
        result = self.class.get(path, :query => opts)
        if result['status_code'] == 200
          return yield result['data']
        else
          raise BitlyError.new(result['status_txt'], result['status_code'])
        end
      end
      
      def get_method(method, klass, opts)
        return get_request("/user/#{method.to_s}", opts){|data|
          results = data[method.to_s].map do |rs|
            rs.inject([]) do |results, obj|
              results << klass.new(obj)
            end
          end
        }        
      end

      def get_clicks(opts={})
        if @clicks.nil? || opts.delete(:force)
          get_request("/user/clicks", opts){|data|
            @clicks = data['clicks'].map { |rs| Bitly::V3::Day.new(rs) }
            @total_clicks = data['total_clicks']
          }          
        end
      end
      
    end
  end
end