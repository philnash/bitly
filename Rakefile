require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "bitly"
  gem.summary = "A ruby wrapper for the bit.ly API"
  gem.description = "A ruby wrapper for the bit.ly API"
  gem.email = "philnash@gmail.com"
  gem.homepage = "http://github.com/philnash/bitly"
  gem.authors = ["philnash"]
  gem.add_dependency 'httparty', ">= 0.5.2"
  gem.add_dependency 'crack', ">= 0.1.4"
  gem.add_dependency 'oauth2', '>= 0.1.1'
  gem.add_development_dependency "shoulda", ">= 0"
  gem.add_development_dependency "jeweler", ">= 1.4.0"
  gem.add_development_dependency "rcov", ">= 0"
  gem.add_development_dependency "flexmock", ">= 0.8.6"
  gem.add_development_dependency "fakeweb", ">= 1.2.8"
  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bitly #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
