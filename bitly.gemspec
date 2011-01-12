# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bitly}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phil Nash"]
  s.date = %q{2011-01-12}
  s.description = %q{Use the bit.ly API to shorten or expand URLs}
  s.email = %q{philnash@gmail.com}
  s.extra_rdoc_files = ["README.txt", "lib/bitly.rb", "lib/bitly/client.rb", "lib/bitly/url.rb", "lib/bitly/utils.rb", "lib/bitly/v3.rb", "lib/bitly/v3/bitly.rb", "lib/bitly/v3/client.rb", "lib/bitly/v3/country.rb", "lib/bitly/v3/day.rb", "lib/bitly/v3/missing_url.rb", "lib/bitly/v3/oauth.rb", "lib/bitly/v3/realtime_link.rb", "lib/bitly/v3/referrer.rb", "lib/bitly/v3/url.rb", "lib/bitly/v3/user.rb", "lib/bitly/version.rb"]
  s.files = ["History.txt", "Manifest", "README.txt", "Rakefile", "bitly.gemspec", "lib/bitly.rb", "lib/bitly/client.rb", "lib/bitly/url.rb", "lib/bitly/utils.rb", "lib/bitly/v3.rb", "lib/bitly/v3/bitly.rb", "lib/bitly/v3/client.rb", "lib/bitly/v3/country.rb", "lib/bitly/v3/day.rb", "lib/bitly/v3/missing_url.rb", "lib/bitly/v3/oauth.rb", "lib/bitly/v3/realtime_link.rb", "lib/bitly/v3/referrer.rb", "lib/bitly/v3/url.rb", "lib/bitly/v3/user.rb", "lib/bitly/version.rb", "test/bitly/test_client.rb", "test/bitly/test_url.rb", "test/bitly/test_utils.rb", "test/fixtures/cnn.json", "test/fixtures/cnn_and_google.json", "test/fixtures/expand_cnn.json", "test/fixtures/expand_cnn_and_google.json", "test/fixtures/google_and_cnn_info.json", "test/fixtures/google_info.json", "test/fixtures/google_stats.json", "test/fixtures/shorten_error.json", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/philnash/bitly}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Bitly", "--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{bitly}
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{Use the bit.ly API to shorten or expand URLs}
  s.test_files = ["test/bitly/test_client.rb", "test/bitly/test_url.rb", "test/bitly/test_utils.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crack>, [">= 0.1.4"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_runtime_dependency(%q<oauth2>, [">= 0.1.1"])
    else
      s.add_dependency(%q<crack>, [">= 0.1.4"])
      s.add_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_dependency(%q<oauth2>, [">= 0.1.1"])
    end
  else
    s.add_dependency(%q<crack>, [">= 0.1.4"])
    s.add_dependency(%q<httparty>, [">= 0.5.2"])
    s.add_dependency(%q<oauth2>, [">= 0.1.1"])
  end
end
