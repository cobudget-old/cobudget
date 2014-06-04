require 'playhouse/context'
require 'playhouse/loader'

module Cobudget
  entities :bucket, :user
  roles :entry_collection

  class BucketAllocationsFromUserEnquiry < Playhouse::Context
    actor :bucket, role: EntryCollection, repository: Bucket
    actor :user, repository: User

    def perform
      Money.new(bucket.balance_from_user(user, bucket.budget.id))
    end
  end
end
