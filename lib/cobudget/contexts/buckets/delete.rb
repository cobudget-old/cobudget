require 'playhouse/context'
require 'cobudget/entities/budget'
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
        #raise NotAuthorizedToCreateBucket unless user.can_delete_bucket?(bucket)
        raise BucketHasAllocations unless bucket.has_no_allocations?

        data = bucket.destroy!
        #Pusher.trigger('buckets', 'deleted', {bucket: data})
      end
    end
  end
end