
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bitly/version"

Gem::Specification.new do |spec|
  spec.name          = "bitly"
  spec.version       = Bitly::VERSION
  spec.authors       = ["Phil Nash"]
  spec.email         = ["philnash@gmail.com"]

  spec.summary       = %q{Use the bit.ly API to shorten or expand URLs}
  spec.description   = %q{Use the bit.ly API to shorten or expand URLs. Check out the API documentation at https://dev.bitly.com/.}
  spec.homepage      = "https://github.com/philnash/bitly"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "oauth2", "< 2.0", ">= 0.5.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.17.1"
  spec.add_development_dependency "webmock", "~> 3.7.6"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "envyable"
end
