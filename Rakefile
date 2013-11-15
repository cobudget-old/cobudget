require 'bundler'
Bundler.require

require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

require 'bundler/setup'
require 'active_record'

@root = File.dirname(__FILE__)
require 'tasks/active_record_tasks'

task default: :ci

desc "Setup databases, gems and other requirements for all apps"
task :setup_ci do
  #do nothing
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty -t ~@wip"
end

desc "Run tests for all parts of this repository"
task :ci => [:features] do
end
