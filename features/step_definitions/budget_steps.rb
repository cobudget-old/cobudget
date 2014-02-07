#require 'cobudget/entities/budget_role'
#require 'cobudget/contexts/allocation_balance_enquiry'

Given /^a budget ([^ ]+)$/ do |budget_name|
  @budget = play.create_budgets(name: budget_name)
  budgets[budget_name] = @budget
end

Given /^a user ([^ ]*) who can administer (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  step("a user #{user_name}")
end

Given /^a bucket ([^ ]*) in (#{CAPTURE_BUDGET})$/ do |bucket_name, budget|
  buckets[bucket_name] = Cobudget::Bucket.create!(name: bucket_name, description: 'Special bucket', budget_id: budget.id)
  #api.create_buckets(budget: budget, bucket_name: bucket_name)
end

When /^([^ ]+) creates a new user ([^ ]+)$/ do |creator_name, target_name|
  creator = users[creator_name]

  users[target_name] = play.create_users(admin: creator, name: target_name, email: "#{target_name}@example.com")
end

When /^([^ ]+) creates an account for ([^ ]+) in (#{CAPTURE_BUDGET})$/ do |admin_name, target_name, budget|
  user = users[target_name]
  admin = users[admin_name]
  play.create_accounts(user: user, admin: admin, budget: budget)
end

When /^([^ ]+) views the available buckets in (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  user = users[user_name]

  @buckets_viewing = play.list_available_buckets(budget: budget, user: user)
end

When /^([^ ]+) creates a bucket in (#{CAPTURE_BUDGET}) with:$/ do |user_name, budget, table|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options[:user] = user
  options[:sponsor] = user
  options[:budget] = budget
  play.create_buckets(options)
end

When /^([^ ]*) updates (#{CAPTURE_BUDGET}) with:$/ do |user_name, budget, table|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options.merge!(user: user, budget: budget)
  play.update_budgets(options)
end

When /^([^ ]*) updates (#{CAPTURE_BUCKET}) in (#{CAPTURE_BUDGET}) with:$/ do |user_name, bucket, budget, table|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options.merge!(bucket: bucket, user: user, budget: budget, sponsor: users[options[:sponsor]])
  play.update_buckets(options)
end

When /^([^ ]*) creates a budget ([^ ]*) with description "(.*?)"$/ do |user_name, budget_name, budget_description|
  user = users[user_name]

  budgets[budget_name] = play.create_budgets(user: user, name: budget_name, description: budget_description)
end

When /^([^ ]*) deletes (#{CAPTURE_BUCKET})$/ do |user_name, bucket|
  user = users[user_name]
  play.delete_buckets(bucket: bucket, user: user)
end

When /^([^ ]*) tries to delete (#{CAPTURE_BUCKET}), it should raise an error$/ do |user_name, bucket|
  user = users[user_name]
  expect { play.delete_buckets(bucket: bucket, user: user) }.to raise_error
end

When /^([^ ]*) grants ([^ ]*) allocation rights of (#{CAPTURE_MONEY}) for (#{CAPTURE_BUDGET})$/ do |admin_name, user_name, amount, budget|
  user = users[user_name]
  admin = users[admin_name]

  allocation_rights[user_name] = play.grant_allocation_rights(admin: admin, user: user, amount: amount, budget: budget)
end

When /^([^ ]*) modifies ([^ ]*)'s allocation rights to (#{CAPTURE_MONEY}) for (#{CAPTURE_BUDGET})$/ do |admin_name, user_name, amount, budget|
  user = users[user_name]
  admin = users[admin_name]

  allocation_rights[user_name] = play.grant_allocation_rights(admin: admin, user: user, amount: amount, budget: budget)
end

When /^([^ ]*) revokes ([^ ]*)'s allocation rights for (#{CAPTURE_BUDGET})$/ do |admin_name, user_name, budget|
  user = users[user_name]
  admin = users[admin_name]

  play.revoke_allocation_rights(admin: admin, user: user, budget: budget)
end

Then /^([^ ]+) should exist as a user$/ do |user_name|
  #list = api.list_users
  Cobudget::User.find_by_name(user_name).should_not be_nil
end

Then /^the available bucket list for (#{CAPTURE_BUDGET}) should be:$/ do |budget, table|
  options = {}
  options[:budget] = budget
  buckets = play.list_available_buckets(options).reload
  result = buckets

  expected = table.hashes

  result.each_with_index do |row, result_index|
    expected_row = expected[result_index]

    expected_row.each do |key, value|
      if value
        value = Money.new(value.to_f*100) if ['minimum', 'maximum'].include?(key)
        value = users[value] if key == 'sponsor'
      end
      row.send(key).should == value
    end
  end
end

Then /^there should be an account for ([^ ]+) in (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  user = users[user_name]
  play.get_accounts(user: user, budget: budget).should_not be_nil
end

Then /^there should be a budget ([^ ]*) with the description "(.*?)"$/ do |budget_name, budget_description|
  budget = budgets[budget_name]

  budget.description.should == budget_description
end

Then /^the ([^ ]*) budget should not exist$/ do |budget_name|
  Cobudget::Budget.find_by_name(budget_name).should be_nil
end

Then /^the ([^ ]*) budget should exist$/ do |budget_name|
  Cobudget::Budget.find_by_name(budget_name).should_not be_nil
end

Then /^the ([^ ]*) budget should have the description "(.*?)"$/ do |budget_name, budget_description|
  budget = Cobudget::Budget.find_by_name(budget_name)
  budget.should_not be_nil
  budget.description.should == budget_description
end

Then /^([^ ]*) should have allocation rights of (#{CAPTURE_MONEY}) for (#{CAPTURE_BUDGET})$/ do |user_name, amount, budget|
  user = users[user_name]

  play.user_remaining_balance_enquiry(user: user, budget: budget).should == amount
end

Then /^([^ ]*) should not have allocation rights for (#{CAPTURE_BUDGET})$/ do  |user_name, budget|
  user = users[user_name]

  play.get_allocation_rights(user: user, budget: budget).should == []
end

Given /^a user ([^ ]*) who has allocation rights of (#{CAPTURE_MONEY}) in (#{CAPTURE_BUDGET})$/ do  |user_name, amount, budget|
  step("a user #{user_name}")
  play.grant_allocation_rights(budget: budget, amount: amount, user: @user, admin: @user)
end


Then /^total used allocations in (#{CAPTURE_BUDGET}) should be (#{CAPTURE_MONEY})$/ do |budget, expected_balance|
  play.budget_allocated_balance_enquiry(budget: budget).should == expected_balance*100
end

Then /^total unallocated in (#{CAPTURE_BUDGET}) should be (#{CAPTURE_MONEY})$/ do |budget, expected_balance|
  play.budget_unallocated_balance_enquiry(budget: budget).should == expected_balance*100
end

Then /^total allocation rights in (#{CAPTURE_BUDGET}) should be (#{CAPTURE_MONEY})$/ do |budget, expected_balance|
  play.budget_total_enquiry(budget: budget).should == expected_balance*100
end

Then /^total budget in (#{CAPTURE_BUDGET}) should be (#{CAPTURE_MONEY})$/ do |budget, expected_balance|
  play.budget_balance_enquiry(budget: budget).should == expected_balance*100
end

