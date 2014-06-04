require 'playhouse/context'
require 'playhouse/loader'

module Cobudget
  entities :bucket
  roles :entry_collection

  class BucketBalanceEnquiry < Playhouse::Context
    actor :bucket, role: EntryCollection, repository: Bucket

    def perform
      Money.new(bucket.balance)
    end
  end
end