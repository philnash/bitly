require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'bitly'
require 'echoe'

Echoe.new('bitly', Bitly::VERSION) do |p|
  p.description = "Use the bit.ly API to shorten or expand URLs"
  p.url = "http://github.com/philnash/bitly"
  p.author = "Phil Nash"
  p.email = "philnash@gmail.com"
  p.extra_deps      = [['crack', '>= 0.1.4'], ['httparty', '>= 0.5.2']]
  p.development_dependencies = [['shoulda', '2.11.3'], ['flexmock', '0.8.7'], ['fakeweb', '1.2.8']]
end