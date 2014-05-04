require 'playhouse/context'
require 'playhouse/loader'

module Cobudget
  entity :budget
  role :budget_of_buckets

  class BudgetAllocatedBalanceEnquiry < Playhouse::Context
    actor :budget, repository: Budget, role: BudgetOfBuckets

    def perform
      Money.new budget.total_allocated
    end
  end
end
