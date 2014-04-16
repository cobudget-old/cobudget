require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/roles/budget_of_buckets'

module Cobudget
  module Buckets
    class ListAvailable < Playhouse::Context
      actor :budget, repository: Budget, role: BudgetOfBuckets
      actor :state
      actor :limit, optional: true

      def perform
        if state == "open"
          if !limit.blank?
            budget.open_buckets.order('created_at desc').limit(limit).load.as_json
          else
            budget.open_buckets.order('created_at desc').load.as_json
          end
        elsif state == "funded"
          if !limit.blank?
            budget.funded_buckets.order('funded_at desc').limit(limit).load.as_json
          else
            budget.funded_buckets.order('funded_at desc').load.as_json
          end
        elsif state == "cancelled"
          if !limit.blank?
            budget.cancelled_buckets.order('cancelled_at desc').limit(limit).load.as_json
          else
            budget.cancelled_buckets.order('cancelled_at desc').load.as_json
          end
        else
          []
          #budget.available_buckets.order('updated_at desc').load.as_json
        end
      end
    end
  end
end
