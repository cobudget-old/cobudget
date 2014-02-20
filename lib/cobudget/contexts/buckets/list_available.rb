require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/roles/budget_of_buckets'

module Cobudget
  module Buckets
    class ListAvailable < Playhouse::Context
      actor :budget, repository: Budget, role: BudgetOfBuckets
      actor :state

      def perform
        if state == "open"
          puts "OPEN"
          budget.open_buckets.order('updated_at desc').load.as_json
        elsif state == "funded"
          puts "FUNDED"
          budget.funded_buckets.order('updated_at desc').load.as_json
        elsif state == "cancelled"
          puts "CANCELLED"
          budget.cancelled_buckets.order('updated_at desc').load.as_json
        else
          []
          #budget.available_buckets.order('updated_at desc').load.as_json
        end
      end
    end
  end
end
