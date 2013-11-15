require 'bundler'
Bundler.require

require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

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

desc "Set environment"
task :environment do
  @environment = ENV['ENV'] || 'development'
end

namespace :db do
  desc "Migrate the database through scripts in db/migrate."
  task :migrate do
    establish_connection
    ActiveRecord::Migrator.migrate("db/migrate/")
    task('db:schema:dump').invoke
  end

  namespace :schema do
    desc "Dump schema"
    task :dump do
      establish_connection
      require 'active_record/schema_dumper'
      File.open('db/schema.rb', "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end

  desc "Seed database"
  task :seed => :environment do
    establish_connection
    load 'db/seeds.rb'
  end

  desc "Drop database"
  task :drop => :environment do
    FileUtils.rm_f("db/#{@environment}.sqlite")
  end

  desc "Reset database"
  task :reset => :environment do
    task('db:drop').invoke
    task('db:create').invoke
  end

  desc "Create database"
  task :create => :environment do
    establish_connection
    load 'db/schema.rb'
    task('db:seed').invoke
  end
end

def establish_connection
  task('environment').invoke
  @db_connection ||= ActiveRecord::Base.establish_connection(YAML.load(File.read(File.join('config','database.yml')))[@environment])
end
