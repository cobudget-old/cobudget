require 'logger'
require 'database_cleaner'
require 'playhouse/theatre'
require 'cobudget_core'

root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
theatre = Playhouse::Theatre.new(root: root_dir, environment: 'test')
theatre.open

$logger = Logger.new(File.join(File.dirname(__FILE__), "../log/features.log"), 'monthly')

#these should be in a helper file

def play
  @play ||= Cobudget::CobudgetPlay.new
end

def budgets
  @budgets ||= {}
end

def allocation_rights
  @allocation_rights ||= {}
end

def buckets
  @buckets ||= {}
end

CAPTURE_MONEY = Transform /^(\$)(\-?[\d\.\,]+)$/ do |currency_symbol, amount|
  amount.gsub(',', '').to_f
end

CAPTURE_BUCKET = Transform /^the ([^ ]*) bucket/ do |bucket_identifier|
  buckets[bucket_identifier] || (raise 'Bucket not found')
end

CAPTURE_BUDGET = Transform /^the ([^ ]*) budget/ do |budget_identifier|
  @budgets[budget_identifier] || (raise 'Budget not found')
end

CAPTURE_USER = Transform /^the ([^ ]*) user/ do |user_identifier|
  @users[user_identifier] || (raise 'User not found')
end

CAPTURE_WITH_DESCRIPTION = Transform /^( ?with description "([^"]*)")?$/ do |unused, description|
  description
end

