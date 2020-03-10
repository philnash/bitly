# frozen_string_literal: true
require "uri"

module Bitly
  module API
    BASE_URL = URI("https://api-ssl.bitly.com/v4")

    autoload :Base, File.join(File.dirname(__FILE__), "api/base.rb")
    autoload :Client, File.join(File.dirname(__FILE__), "api/client.rb")
    autoload :ClickMetric, File.join(File.dirname(__FILE__), "api/click_metric.rb")
    autoload :Bitlink, File.join(File.dirname(__FILE__), "api/bitlink.rb")
    autoload :Organization, File.join(File.dirname(__FILE__), "api/organization.rb")
    autoload :Group, File.join(File.dirname(__FILE__), "api/group.rb")
    autoload :User, File.join(File.dirname(__FILE__), "api/user.rb")
    autoload :BSD, File.join(File.dirname(__FILE__), "api/bsd.rb")
    autoload :OAuthApp, File.join(File.dirname(__FILE__), "api/oauth_app.rb")
    autoload :ShortenCounts, File.join(File.dirname(__FILE__), "api/shorten_counts.rb")
  end
end
