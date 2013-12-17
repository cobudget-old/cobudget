require 'playhouse/role'
require 'cobudget/roles/allocation_collection'

module Cobudget
  module BudgetOfBuckets
    include Playhouse::Role

    actor_dependency :buckets
    actor_dependency :accounts

    def total_allocated
      buckets.to_a.sum do |bucket|
        AllocationCollection.cast_actor(bucket).total_allocation_balance
      end
    end

    def total_available_for_allocation
      #Total in users accounts that they haven't moved into buckets
      user_accounts = accounts.where("USER_ID IS NOT NULL")
      user_accounts.to_a.sum do |account|
        balance = TransactionCollection.cast_actor(account).balance
        puts balance.inspect + "!!!!! available for allocation in #{account.name}"
        balance
      end
    end
  end
end