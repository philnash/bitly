# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bitly/version"

Gem::Specification.new do |spec|
  spec.name          = "bitly"
  spec.version       = Bitly::VERSION
  spec.authors       = ["Phil Nash"]
  spec.email         = ["philnash@gmail.com"]

  spec.summary       = %q{Use the Bitly API to shorten or expand URLs}
  spec.description   = %q{Use the Bitly API version 4 to shorten or expand URLs. Check out the API documentation at https://dev.bitly.com/.}
  spec.homepage      = "https://github.com/philnash/bitly"
  spec.license       = "MIT"

  spec.metadata      = {
    "bug_tracker_uri"   => "https://github.com/philnash/bitly/issues",
    "changelog_uri"     => "https://github.com/philnash/bitly/blob/master/History.txt",
    "documentation_uri" => "https://www.rubydoc.info/gems/bitly/",
    "homepage_uri"      => "https://github.com/philnash/bitly",
    "source_code_uri"   => "https://github.com/philnash/bitly"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|bin|docs)/})
  end
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_runtime_dependency "oauth2", "< 2.0", ">= 0.5.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.17.1"
  spec.add_development_dependency "webmock", "~> 3.7.6"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "envyable"
end
