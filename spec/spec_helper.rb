require 'playhouse/theatre'
require 'cobudget_core'
require 'database_cleaner'

root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
theatre = Playhouse::Theatre.new(root: root_dir, environment: 'test')
theatre.open

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end

module UsesDatabase
  def self.included(base)
    base.before(:each) do
      DatabaseCleaner.start
    end
    base.after(:each) do
      DatabaseCleaner.clean
    end
  end
end