require 'cobudget/entities/budget'
#require 'cobudget/entities/allocation'
require 'cobudget/entities/user'
#require 'cobudget/entities/budget_participant_role'

#require 'cobudget/contexts/create_allocation'
#require 'cobudget/contexts/allocation_balance_enquiry'


When /^([^ ]+) views the buckets in the (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  user = users[user_name]

  @buckets_viewing = api.list_buckets(budget: budget, user: user)
end


Then /^they should see (#{CAPTURE_BUCKET}) in the bucket list$/ do |bucket|
  @buckets_viewing = api.list_buckets(budget: @budget, user: @user)
  @buckets_viewing.include?bucket
end

Transform /^table:name,description,minimum,maximum,sponsor$/ do |table|
  table.hashes.map! do |h|
    h.each_pair do |k,v|
      h[k] = nil if v == ''
    end
  end

  table
end


Then /^(#{CAPTURE_BUCKET}) should have a balance of (#{CAPTURE_MONEY})$/ do |bucket, amount|
  api.bucket_balance_enquiry(bucket: bucket).should == Money.new(amount*100)
end

When /^([^ ]*) allocates (#{CAPTURE_MONEY}) to (#{CAPTURE_BUCKET})$/ do |user_name, amount, bucket|
  user = users[user_name]

  options = {}
  options[:bucket] = bucket
  options[:amount] = amount
  options[:admin] = user
  options[:user] = user
  api.create_allocations(options)
end

When /^([^ ]*) tries to allocate (#{CAPTURE_MONEY}) to (#{CAPTURE_BUCKET}) but fails$/ do |user_name, amount, bucket|
  user = users[user_name]

  options = {}
  options[:bucket] = bucket
  options[:amount] = amount
  options[:admin] = user
  options[:user] = user
  expect{ api.create_allocations(options)}.to raise_error#(Cobudget::Allocations::Create::NotAuthorisedToAllocate)
end

When /^([^ ]*) changes the allocation in (#{CAPTURE_BUCKET}) to (#{CAPTURE_BUCKET})$/ do |user_name, from_bucket, to_bucket|
  user = users[user_name]
  from_bucket = buckets[from_bucket]
  to_bucket = buckets[to_bucket]

  options = table.rows_hash.symbolize_keys
  options[:from_bucket] = bucket
  options[:to_bucket] = to_bucket
  api.create_allocation(options)
end

When /^([^ ]*) removes the (#{CAPTURE_MONEY}) allocation in (#{CAPTURE_BUCKET})$/ do |user_name, amount, bucket|
  user = users[user_name]

  api.remove_allocations(bucket: bucket, amount: amount, admin: user, user: user)
end

Then /^([^ ]*) should have a remaining allocation of (#{CAPTURE_MONEY}) in (#{CAPTURE_BUDGET})$/ do |user_name, amount, budget|
  user = users[user_name]

  api.user_remaining_balance_enquiry(budget: budget, user: user).should == amount
end

