require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/roles/budget_of_buckets'

module Cobudget
  class BudgetTotalEnquiry < Playhouse::Context
    actor :budget, repository: Budget, role: BudgetOfBuckets

    def perform
      budget.total_in_budget
    end
  end
end
