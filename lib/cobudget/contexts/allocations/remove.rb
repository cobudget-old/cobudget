require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module Allocations
    class Remove < Playhouse::Context
      class NotAuthorizedToRemoveAllocation < Exception; end

      actor :admin, repository: User#, role: BucketAuthorizer

      actor :user, repository: User, role: Allocator
      actor :bucket, repository: Bucket

      def perform
        allocation = user.get_allocation_for_bucket(bucket)
        if allocation
          allocation.delete
        end
      end
    end
  end
end
