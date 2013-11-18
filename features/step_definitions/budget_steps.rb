#require 'cobudget/entities/budget_role'
#require 'cobudget/contexts/allocation_balance_enquiry'

def budgets
  @budgets ||= {}
end

Given /^a budget ([^ ]+)$/ do |budget_name|
  @budget = Cobudget::Budget.create!(name: budget_name)
  budgets[budget_name] = @budget
end

Given /^a user ([^ ]*) who can administer (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  step("a user #{user_name}")
  #Cobudget::BudgetAdministratorRole.create!(user_id: @user.id, budget_id: budget.id)
end

Given /^a bucket ([^ ]*) in (#{CAPTURE_BUDGET})$/ do |bucket_name, budget|
  @buckets ||= {}
  @buckets[bucket_name] = Cobudget::Bucket.create!(name: bucket_name, description: 'Special bucket', budget_id: budget.id)
  #api.create_buckets(budget: budget, bucket_name: bucket_name)
end

Given /^a list of budgets$/ do
  puts budgets.inspect
end

When /^([^ ]+) views the buckets in (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  user = users[user_name]

  @buckets_viewing = api.list_buckets(budget: budget, user: user)
end


When /^([^ ]+) creates a bucket in (#{CAPTURE_BUDGET}) with:$/ do |user_name, budget, table|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options[:user] = user
  options[:sponsor] = user
  options[:budget] = budget
  api.create_buckets(options).to_s
end

Then /^the bucket list for (#{CAPTURE_BUDGET}) should be:$/ do |budget, table|
  options = {}
  options[:budget] = budget
  @buckets = api.list_buckets(options).reload
  result = @buckets

  expected = table.hashes

  result.each_with_index do |row, result_index|
    expected_row = expected[result_index]

    expected_row.each do |key, value|
      if value
        value = Money.new(value.to_f) if ['minimum', 'maximum'].include?(key)
        value = users[value] if key == 'sponsor'
      end
      row.send(key).should == value
    end
  end
end

When /^([^ ]*) updates (#{CAPTURE_BUDGET}) with:$/ do |user_name, budget, table|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options.merge!(user: user, budget: budget)
  api.update_budgets(options)
end

When /^([^ ]*) updates (#{CAPTURE_BUCKET}) in (#{CAPTURE_BUDGET}) with:$/ do |user_name, bucket, budget, table|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options.merge!(bucket: bucket, user: user, budget: budget, sponsor: users[options[:sponsor]])
  api.update_buckets(options)
end

When /^([^ ]*) creates a budget ([^ ]*) with description "(.*?)"$/ do |user_name, budget_name, budget_description|
  user = users[user_name]

  budgets[budget_name] = api.create_budgets(user: user, name: budget_name, description: budget_description)
end

When /^([^ ]*) deletes (#{CAPTURE_BUCKET})$/ do |user_name, bucket|
  user = users[user_name]
  api.delete_buckets(bucket: bucket, user: user)
end

Then /^there should be a budget ([^ ]*) with the description "(.*?)"$/ do |budget_name, budget_description|
  budget = budgets[budget_name]

  budget.description.should == budget_description
end

Then /^the ([^ ]*) budget should not exist$/ do |budget_name|
  budgets[budget_name].should be_nil
end

Then /^(#{CAPTURE_BUDGET}) should have the description "(.*?)"$/ do |budget, budget_description|
  budget.description.should == budget_description
end

Transform /^table:name,description,minimum,maximum,sponsor$/ do |table|
  table.hashes.map! do |h|
    h.each_pair do |k,v|
      h[k] = nil if v == ''
    end
  end

  table
end



#----------- experimental stuff below -------- #


Given /^a user ([^ ]*) who has allocation rights of (#{CAPTURE_MONEY}) in (#{CAPTURE_BUDGET})$/ do  |user_name, amount, budget|
  step("a user #{user_name}")
  Cobudget::BudgetParticipantRole.create!(user_id: @user_id, budget_id: budget.id)
  api.set_allocation_for_user(budget: budget, amount: amount, user: @user)
end

When /^the admin gives an allocation of (#{CAPTURE_MONEY}) to ([^ ]*) for (#{CAPTURE_BUDGET})$/ do |admin_name, amount, user_name, budget|
  user = users[user_name]
  Cobudget::BudgetParticipantRole.create!(user_id: user.id, budget_id: budget.id)
  api.set_allocation_for_user(budget: budget, amount: amount, user: user)
end

Then /^total allocations in (#{CAPTURE_BUDGET}) should be (#{CAPTURE_MONEY})$/ do |budget, expected_balance|
  api.budget_allocated_balance_enquiry(budget: budget).should == expected_balance
end

Then /^total unallocated in (#{CAPTURE_BUDGET}) should be (#{CAPTURE_MONEY})$/ do |budget, expected_balance|
  api.budget_unallocated_balance_enquiry(budget: budget).should == expected_balance
end

Then /^total budget in (#{CAPTURE_BUDGET}) should be (#{CAPTURE_MONEY})$/ do |budget, expected_balance|
  api.budget_balance_enquiry(budget: budget).should == expected_balance
end

