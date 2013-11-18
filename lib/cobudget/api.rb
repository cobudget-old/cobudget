require 'playhouse/support/files'
require 'playhouse/play'
require_all File.dirname(__FILE__), 'contexts/**/*.rb'


module Cobudget
  class API < Playhouse::Play
    context UserRemainingBalanceEnquiry
    context BucketBalanceEnquiry
    context BudgetAllocatedBalanceEnquiry
    context BudgetUnallocatedBalanceEnquiry
    context BudgetTotalAvailableForAllocationEnquiry

    contexts_for Budgets
    contexts_for Buckets
    contexts_for AllocationRights
    contexts_for Allocations

    def self.name
      'cobudget'
    end
  end
end