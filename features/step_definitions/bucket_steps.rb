require 'cobudget/entities/budget'
#require 'cobudget/entities/allocation'
require 'cobudget/entities/user'
#require 'cobudget/entities/budget_participant_role'

#require 'cobudget/contexts/create_allocation'
#require 'cobudget/contexts/allocation_balance_enquiry'


When /^([^ ]+) views the buckets in the (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  user = users[user_name]

  @buckets_viewing = play.list_buckets(budget: budget, user: user)
end


Then /^they should see (#{CAPTURE_BUCKET}) in the available bucket list$/ do |bucket|
  @buckets_viewing = play.list_available_buckets(budget: @budget, user: @user, state: 'open')
  @buckets_viewing.include?bucket
end

Then /^they should see (#{CAPTURE_BUCKET}) in the bucket list$/ do |bucket|
  @buckets_viewing = play.list_all_buckets(budget: @budget, user: @user)
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
  play.bucket_balance_enquiry(bucket: bucket).should == Money.new(amount*100)
end

When /^([^ ]*) allocates (#{CAPTURE_MONEY}) to (#{CAPTURE_BUCKET})$/ do |user_name, amount, bucket|
  user = users[user_name]

  options = {}
  options[:bucket] = bucket
  options[:amount] = amount
  options[:current_user] = user
  options[:user] = user
  play.create_allocations(options)
end

When /^([^ ]*) tries to allocate (#{CAPTURE_MONEY}) to (#{CAPTURE_BUCKET}) but fails$/ do |user_name, amount, bucket|
  user = users[user_name]

  options = {}
  options[:bucket] = bucket
  options[:amount] = amount
  options[:current_user] = user
  options[:user] = user
  expect{ play.create_allocations(options)}.to raise_error
end

When /^([^ ]*) changes the allocation in (#{CAPTURE_BUCKET}) to (#{CAPTURE_BUCKET})$/ do |user_name, from_bucket, to_bucket|
  user = users[user_name]
  from_bucket = buckets[from_bucket]
  to_bucket = buckets[to_bucket]

  options = table.rows_hash.symbolize_keys
  options[:from_bucket] = bucket
  options[:to_bucket] = to_bucket
  play.create_allocations(options)
end

When /^([^ ]*) removes the (#{CAPTURE_MONEY}) allocation in (#{CAPTURE_BUCKET})$/ do |user_name, amount, bucket|
  user = users[user_name]

  play.remove_allocations(bucket: bucket, amount: amount, current_user: user, user: user)
end

Then /^([^ ]*) should have a remaining allocation of (#{CAPTURE_MONEY}) in (#{CAPTURE_BUDGET})$/ do |user_name, amount, budget|
  user = users[user_name]

  play.user_remaining_balance_enquiry(budget: budget, user: user).should == amount
end

Then /^([^ ]*) should have allocated (#{CAPTURE_MONEY}) to (#{CAPTURE_BUCKET})$/ do |user_name, amount, bucket|
  user = users[user_name]

  play.bucket_allocations_from_user_enquiry(bucket: bucket, user: user).should == amount
end


Then /([^ ]*) archives (#{CAPTURE_BUCKET})$/ do |user_name, bucket|
  user = users[user_name]
  play.archive_buckets(user: user, bucket: bucket)
end

Then /^the allocation total list for (#{CAPTURE_BUCKET}) should include (#{CAPTURE_MONEY}) allocation by ([^ ]*)$/ do |bucket, amount, user_name|
  user = users[user_name]
  results = play.list_by_bucket_allocations(bucket: bucket)

  found_result = false
  results.each do |result|
    if result["user_id"] == user.id
      result["user_color"].should == user.bg_color
      result["amount"].should == amount*100
      found_result = true
    end
  end

  #how else to force it to fail?
  true.should == false unless found_result
end
