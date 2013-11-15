require 'cobudget/entities/budget'
#require 'cobudget/entities/allocation'
require 'cobudget/entities/user'
#require 'cobudget/entities/budget_participant_role'

#require 'cobudget/contexts/create_allocation'
#require 'cobudget/contexts/allocation_balance_enquiry'

CAPTURE_MONEY = Transform /^(\$)(\-?[\d\.\,]+)$/ do |currency_symbol, amount|
  Money.new(amount.gsub(',', '').to_f)
end

CAPTURE_BUCKET = Transform /^([^ ]*) bucket/ do |bucket_identifier|
  @buckets[bucket_identifier] || (raise 'Bucket not found')
end

CAPTURE_BUDGET = Transform /^([^ ]*) budget/ do |budget_identifier|
  @budgets[budget_identifier] || (raise 'Budget not found')
end

CAPTURE_WITH_DESCRIPTION = Transform /^( ?with description "([^"]*)")?$/ do |unused, description|
  description
end

Given /^a bucket ([^ ]*) in (#{CAPTURE_BUDGET})$/ do |bucket_name, budget|
  @buckets ||= {}
  @buckets[bucket_name] = Cobudget::Bucket.create!(name: bucket_name, description: 'Special bucket', budget_id: budget.id)
  #api.create_buckets(budget: budget, bucket_name: bucket_name)
end

When /^([^ ]+) views the buckets in the budget (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  user = users[user_name]

  @buckets_viewing = api.list_buckets(budget: budget, user: user)
end


Then /^they should see (#{CAPTURE_BUCKET}) in the bucket list$/ do |bucket|
  @buckets_viewing.include?bucket
end






#--------------- experimental stuff below --------------#


Then /^(#{CAPTURE_BUCKET}) should have a balance of (#{CAPTURE_MONEY})$/ do |bucket, amount|
  api.bucket_balance_enquiry(bucket: bucket).should == amount
end

When /^([^ ]*) allocates (#{CAPTURE_MONEY}) to the bucket (#{CAPTURE_BUCKET})$/ do |user_name, amount, bucket|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options[:bucket] = bucket
  options[:amount] = amount
  api.update_allocations(options)
end

When /^([^ ]*) changes the allocation in (#{CAPTURE_BUCKET}) to (#{CAPTURE_BUCKET})$/ do |user_name, from_bucket, to_bucket|
  user = users[user_name]
  from_bucket = buckets[from_bucket]
  to_bucket = buckets[to_bucket]

  options = table.rows_hash.symbolize_keys
  options[:from_bucket] = bucket
  options[:to_bucket] = to_bucket
  api.transfer_allocation(options)
end

When /^([^ ]*) removes the allocation in (#{CAPTURE_BUCKET})$/ do |user_name, bucket|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options[:bucket] = bucket
  api.update_allocations(options)
end

Then /^([^ ]*) should have a remaining allocation of (#{CAPTURE_MONEY}) in (#{CAPTURE_BUDGET})$/ do |user_name, budget_name|
  user = users[user_name]
  budget = budgets[budget_name]

  api.user_allocation_balance_enquiry(bucket: bucket).should == amount
end
