require 'bundler'
Bundler.require

APPS = %w(cobudget cobudget_sinatra)

desc "Setup databases, gems and other requirements for all apps"
task :setup_ci do
  APPS.each do |app|
    system %{cd #{app}; pwd; bundle exec rake setup_ci}
  end
end

desc "Run tests for all parts of this repository"
task :ci => :setup_ci do
  APPS.each do |app|
    sh %{cd #{app}; bundle exec rake ci}
  end
end

task default: :ci
namespace :db do
  desc "Migrate the database through scripts in db/migrate."
  task :migrate do
    ActiveRecord::Base.establish_connection(YAML.load(File.read(File.join('config','database.yml')))[ENV['ENV'] ? ENV['ENV'] : 'development'])
    ActiveRecord::Migrator.migrate("db/migrate/")
  end
end
