require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class ListAvailable < Playhouse::Context
      actor :budget, repository: Budget, role: BudgetOfBuckets

      def perform
        budget.available_buckets.order('updated_at desc').load
      end
    end
  end
end
