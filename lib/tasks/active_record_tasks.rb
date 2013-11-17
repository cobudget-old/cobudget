include ActiveRecord::Tasks

db_dir = File.join(@root, 'db')
config_dir = File.join(@root, 'config')

DatabaseTasks.env = ENV['ENV'] || 'development'
puts DatabaseTasks.env
DatabaseTasks.root = @root
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(config_dir, 'database.yml')))
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

require File.join(db_dir, 'seeds')
DatabaseTasks.seed_loader = Cobudget::SeedLoader

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env
end

load 'active_record/railties/databases.rake'