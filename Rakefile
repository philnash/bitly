require 'bundler/gem_tasks'

require 'rake/testtask'
task :default => [:test]

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/test_*.rb']
  t.ruby_opts = ['-Itest']
  t.ruby_opts << '-r rubygems' if defined? Gem
end
