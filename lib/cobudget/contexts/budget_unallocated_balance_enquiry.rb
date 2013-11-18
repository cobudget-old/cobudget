require 'playhouse/context'
require 'cobudget/roles/budget_of_buckets'

module Cobudget
  class BudgetUnallocatedBalanceEnquiry < Playhouse::Context
    actor :budget, repository: Budget, role: BudgetOfBuckets

    def perform
      budget.total_available_for_allocation - budget.total_allocated
    end
  end
end