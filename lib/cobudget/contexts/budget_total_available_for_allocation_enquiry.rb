require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/roles/budget_of_buckets'

module Cobudget
  class BudgetTotalAvailableForAllocationEnquiry < Playhouse::Context
    actor :budget, repository: Budget, role: BudgetOfBuckets

    def perform
      budget.total_available_for_allocation
    end
  end
end
