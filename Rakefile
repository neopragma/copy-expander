require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:fast) do |t|
  puts 'running fast specs...'
  t.rspec_opts = '--tag ~slow'
end  

RSpec::Core::RakeTask.new(:slow) do |t|
  puts 'running slow specs...'
  t.pattern = [ "spec/**/*_spec.rb" ]
  t.rspec_opts = '--tag slow'
end  

RSpec::Core::RakeTask.new(:functional) do |t|
  puts 'running functional specs...'
  t.pattern = [ "spec/**/*_functional.rb" ]
end  

task(:help) do |t|
  puts 'rake help for expander:'
  puts 'rake help       => this text'
  puts 'rake fast       => run specs not tagged slow (default)'
  puts 'rake slow       => run specs tagged slow'
  puts 'rake all        => run all specs'
  puts 'rake functional => run functional checks (no mocks)'
end  

task :default => :fast
task :all => [ :fast, :slow, :functional ]