require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/roles/budget_participant'
require 'cobudget/roles/entry_collection'

module Cobudget
  class BucketAllocationsFromUserEnquiry < Playhouse::Context
    actor :bucket, role: EntryCollection, repository: Bucket
    actor :user, repository: User

    def perform
      Money.new(bucket.balance_from_user(user, bucket.budget.id))
    end
  end
end
