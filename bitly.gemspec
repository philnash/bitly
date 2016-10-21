# -*- encoding: utf-8 -*-
# stub: bitly 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bitly".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Phil Nash".freeze]
  s.date = "2016-10-21"
  s.description = "Use the bit.ly API to shorten or expand URLs".freeze
  s.email = "philnash@gmail.com".freeze
  s.extra_rdoc_files = ["LICENSE.md".freeze, "README.md".freeze, "lib/bitly.rb".freeze, "lib/bitly/client.rb".freeze, "lib/bitly/config.rb".freeze, "lib/bitly/url.rb".freeze, "lib/bitly/utils.rb".freeze, "lib/bitly/v3.rb".freeze, "lib/bitly/v3/bitly.rb".freeze, "lib/bitly/v3/client.rb".freeze, "lib/bitly/v3/country.rb".freeze, "lib/bitly/v3/day.rb".freeze, "lib/bitly/v3/missing_url.rb".freeze, "lib/bitly/v3/oauth.rb".freeze, "lib/bitly/v3/realtime_link.rb".freeze, "lib/bitly/v3/referrer.rb".freeze, "lib/bitly/v3/url.rb".freeze, "lib/bitly/v3/user.rb".freeze, "lib/bitly/version.rb".freeze]
  s.files = ["Gemfile".freeze, "History.txt".freeze, "LICENSE.md".freeze, "Manifest".freeze, "README.md".freeze, "Rakefile".freeze, "bitly.gemspec".freeze, "lib/bitly.rb".freeze, "lib/bitly/client.rb".freeze, "lib/bitly/config.rb".freeze, "lib/bitly/url.rb".freeze, "lib/bitly/utils.rb".freeze, "lib/bitly/v3.rb".freeze, "lib/bitly/v3/bitly.rb".freeze, "lib/bitly/v3/client.rb".freeze, "lib/bitly/v3/country.rb".freeze, "lib/bitly/v3/day.rb".freeze, "lib/bitly/v3/missing_url.rb".freeze, "lib/bitly/v3/oauth.rb".freeze, "lib/bitly/v3/realtime_link.rb".freeze, "lib/bitly/v3/referrer.rb".freeze, "lib/bitly/v3/url.rb".freeze, "lib/bitly/v3/user.rb".freeze, "lib/bitly/version.rb".freeze, "test/bitly/test_client.rb".freeze, "test/bitly/test_config.rb".freeze, "test/bitly/test_url.rb".freeze, "test/bitly/test_utils.rb".freeze, "test/fixtures/cnn.json".freeze, "test/fixtures/cnn_and_google.json".freeze, "test/fixtures/expand_cnn.json".freeze, "test/fixtures/expand_cnn_and_google.json".freeze, "test/fixtures/google_and_cnn_info.json".freeze, "test/fixtures/google_info.json".freeze, "test/fixtures/google_stats.json".freeze, "test/fixtures/shorten_error.json".freeze, "test/test_helper.rb".freeze]
  s.homepage = "http://github.com/philnash/bitly".freeze
  s.rdoc_options = ["--line-numbers".freeze, "--title".freeze, "Bitly".freeze, "--main".freeze, "README.md".freeze]
  s.rubyforge_project = "bitly".freeze
  s.rubygems_version = "2.6.6".freeze
  s.summary = "Use the bit.ly API to shorten or expand URLs".freeze
  s.test_files = ["test/bitly/test_client.rb".freeze, "test/bitly/test_config.rb".freeze, "test/bitly/test_url.rb".freeze, "test/bitly/test_utils.rb".freeze, "test/test_helper.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.3"])
      s.add_runtime_dependency(%q<httparty>.freeze, [">= 0.7.6"])
      s.add_runtime_dependency(%q<oauth2>.freeze, ["< 2.0", ">= 0.5.0"])
      s.add_development_dependency(%q<echoe>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_development_dependency(%q<flexmock>.freeze, [">= 0"])
      s.add_development_dependency(%q<fakeweb>.freeze, [">= 0"])
      s.add_development_dependency(%q<activesupport>.freeze, ["~> 3.2"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.8.3"])
    else
      s.add_dependency(%q<multi_json>.freeze, ["~> 1.3"])
      s.add_dependency(%q<httparty>.freeze, [">= 0.7.6"])
      s.add_dependency(%q<oauth2>.freeze, ["< 2.0", ">= 0.5.0"])
      s.add_dependency(%q<echoe>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_dependency(%q<flexmock>.freeze, [">= 0"])
      s.add_dependency(%q<fakeweb>.freeze, [">= 0"])
      s.add_dependency(%q<activesupport>.freeze, ["~> 3.2"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.8.3"])
    end
  else
    s.add_dependency(%q<multi_json>.freeze, ["~> 1.3"])
    s.add_dependency(%q<httparty>.freeze, [">= 0.7.6"])
    s.add_dependency(%q<oauth2>.freeze, ["< 2.0", ">= 0.5.0"])
    s.add_dependency(%q<echoe>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
    s.add_dependency(%q<flexmock>.freeze, [">= 0"])
    s.add_dependency(%q<fakeweb>.freeze, [">= 0"])
    s.add_dependency(%q<activesupport>.freeze, ["~> 3.2"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.8.3"])
  end
end
