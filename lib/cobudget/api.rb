require 'playhouse/support/files'
require 'playhouse/play'
require_all File.dirname(__FILE__), 'contexts/**/*.rb'

module Cobudget
  class API < Playhouse::Play
    #context UpdateAllocations
    #context SetAllocationForUser
    #context BudgetAllocatedBalanceEnquiry
    #context BudgetUnallocatedBalanceEnquiry
    #context BudgetBalanceEnquiry

    #context BucketBalanceEnquiry
    #context CreateBuckets
    #context TransferAllocation
    #context ListAllocations
    #context UserAllocationBalanceEnquiry

    # TODO: Need a way of grouping these in the API
    context Buckets::Create
    context Buckets::List

    def self.name
      'cobudget'
    end
  end
end