require 'playhouse/context'
require 'playhouse/loader'

module Cobudget
  entities :bucket
  roles :entry_collection

  class BucketPercentageEnquiry < Playhouse::Context
    actor :bucket, role: EntryCollection, repository: Bucket

    def perform
      return 100 if bucket.maximum.nil?
      ((bucket.balance).to_f / bucket.maximum_cents).to_f
    end
  end
end