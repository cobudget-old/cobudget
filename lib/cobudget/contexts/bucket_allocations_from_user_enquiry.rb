require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/roles/budget_participant'

module Cobudget
  class BucketAllocationsFromUserEnquiry < Playhouse::Context
    actor :bucket, role: TransactionCollection, repository: Bucket
    actor :user, repository: User

    def perform
      Money.new(bucket.balance_from_user(user))
    end
  end
end
