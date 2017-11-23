# -*- encoding: utf-8 -*-
# stub: bitly 1.1.0 ruby lib
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitly/version'

Gem::Specification.new do |spec|
  spec.name                   = "bitly"
  spec.version                = Bitly::VERSION
  spec.authors                = ["Phil Nash"]
  spec.email                  = "philnash@gmail.com"

  spec.summary                = "Use the bit.ly API to shorten or expand URLs"
  spec.description            = "Use the bit.ly API to shorten or expand URLs"
  spec.homepage               = "http://github.com/philnash/bitly"
  spec.license                = "MIT"

  spec.files                  = `git ls-files -z`.split("\x0")
  spec.executables            = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files             = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths          = ["lib"]
  spec.required_ruby_version  = '>= 1.8.7'

  spec.rdoc_options           = ["--line-numbers", "--title", "Bitly", "--main", "README.md"]
  spec.extra_rdoc_files       = ["LICENSE.md", "README.md"]

  spec.add_runtime_dependency "multi_json", "~> 1.3"
  spec.add_runtime_dependency "httparty", ">= 0.7.6"
  spec.add_runtime_dependency "oauth2", "< 2.0", ">= 0.5.0"
  spec.add_runtime_dependency "rack", "<2" if RUBY_VERSION.to_f < 2.2

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "shoulda", "~> 3.5.0"
  spec.add_development_dependency "flexmock"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "minitest", "~> 5.8.3"
end
