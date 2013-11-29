require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/roles/allocation_collection'

module Cobudget
  class BucketBalanceEnquiry < Playhouse::Context
    actor :bucket, role: AllocationCollection, repository: Bucket

    def perform
      Money.new(bucket.total_allocation_balance)
    end
  end
end