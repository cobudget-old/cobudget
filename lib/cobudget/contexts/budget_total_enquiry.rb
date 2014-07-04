require 'playhouse/context'
require 'playhouse/loader'

module Cobudget
  entity :budget
  role :budget_of_buckets

  class BudgetTotalEnquiry < Playhouse::Context
    actor :budget, repository: Budget, role: BudgetOfBuckets

    def perform
      Money.new budget.total_in_budget
    end
  end
end
