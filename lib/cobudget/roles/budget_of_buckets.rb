require 'playhouse/role'
require 'cobudget/roles/allocation_collection'

module Cobudget
  module BudgetOfBuckets
    include Playhouse::Role

    actor_dependency :buckets
    actor_dependency :allocation_rights

    def total_allocated
      buckets.to_a.sum do |bucket|
        AllocationCollection.cast_actor(bucket).total_allocation_balance
      end
    end

    def total_available_for_allocation
      allocation_rights.to_a.sum do |right|
        right.amount
      end
    end
  end
end