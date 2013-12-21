require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/roles/budget_participant'

module Cobudget
  class BucketBalanceEnquiry < Playhouse::Context
    actor :bucket, role: TransactionCollection, repository: Bucket

    def perform
      Money.new(bucket.balance)
    end
  end
end