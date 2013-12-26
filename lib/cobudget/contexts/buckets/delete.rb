require 'playhouse/context'
require 'cobudget/roles/transaction_collection'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class Delete < Playhouse::Context
      class NotAuthorizedToDeleteBucket < Exception; end
      class BucketHasAllocations < Exception; end

      actor :user, repository: User
      actor :bucket, repository: Bucket, role: TransactionCollection

      def perform
        #raise NotAuthorizedToDeleteBucket unless user.can_delete_bucket?(bucket)
        raise BucketHasAllocations unless bucket.has_no_allocations?

        data = bucket.destroy!
        #Pusher.trigger('buckets', 'deleted', {bucket: data})
      end
    end
  end
end

