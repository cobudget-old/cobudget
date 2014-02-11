require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/roles/budget_of_buckets'

module Cobudget
  module Buckets
    class ListAvailable < Playhouse::Context
      actor :budget, repository: Budget, role: BudgetOfBuckets

      def perform
        budget.available_buckets.order('updated_at desc').load.as_json
      end
    end
  end
end
