require 'rspec/core/rake_task'

desc "Setup sinatra interface for CI"
task :setup_ci do
  puts "nothing to setup"
end

require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty -t ~@wip"
end

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
end

desc "Run cukes"
  task :ci => [:features, :spec] do
end

task :default => [:ci]
