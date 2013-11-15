require 'bundler'
Bundler.require

require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

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

task default: :ci
namespace :db do
  desc "Migrate the database through scripts in db/migrate."
  task :migrate do
    ActiveRecord::Base.establish_connection(YAML.load(File.read(File.join('config','database.yml')))[ENV['ENV'] ? ENV['ENV'] : 'development'])
    ActiveRecord::Migrator.migrate("db/migrate/")
  end

  desc "Populate fixtures"
  task :load do

  end
end
