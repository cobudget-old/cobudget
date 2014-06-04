require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/roles/budget_of_buckets'

module Cobudget
  class BudgetUnallocatedBalanceEnquiry < Playhouse::Context
    actor :budget, repository: Budget, role: BudgetOfBuckets

    def perform
      Money.new budget.total_available_for_allocation
    end
  end
end
