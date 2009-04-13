# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bitly}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phil Nash"]
  s.date = %q{2009-04-13}
  s.description = %q{Use the bit.ly API to shorten or expand URLs}
  s.email = %q{philnash@gmail.com}
  s.extra_rdoc_files = ["lib/bitly/client.rb", "lib/bitly/url.rb", "lib/bitly/utils.rb", "lib/bitly/version.rb", "lib/bitly.rb", "README.txt"]
  s.files = ["bitly.gemspec", "History.txt", "lib/bitly/client.rb", "lib/bitly/url.rb", "lib/bitly/utils.rb", "lib/bitly/version.rb", "lib/bitly.rb", "Manifest", "Rakefile", "README.txt", "test/test_bitly.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/philnash/bitly}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Bitly", "--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{bitly}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Use the bit.ly API to shorten or expand URLs}
  s.test_files = ["test/test_bitly.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
  end
end
