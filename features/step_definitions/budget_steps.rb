#require 'cobudget/entities/budget_role'
#require 'cobudget/contexts/allocation_balance_enquiry'

def budgets
  @budgets ||= {}
end

Given /^a budget ([^ ]+)$/ do |budget_name|
  budgets[budget_name] = Cobudget::Budget.create!(name: budget_name)
end



#----------- experimental stuff below -------- #

Given /^a user ([^ ]*) who can administer (#{CAPTURE_BUDGET})$/ do |user_name, budget|
  step("a user #{user_name}")
  Cobudget::BudgetAdministratorRole.create!(user_id: @user.id, budget_id: budget.id)
end

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

