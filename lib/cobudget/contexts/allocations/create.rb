require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
require 'cobudget/roles/allocator'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module Allocations
    class Create < Playhouse::Context
      class NotAuthorizedToAllocate < Exception; end

      actor :admin, repository: User#, role: BucketAuthorizer

      actor :user, repository: User, role: Allocator
      actor :bucket, repository: Bucket
      actor :amount, composer: MoneyComposer

      def attributes
        actors_except :admin
      end

      def perform
        raise NotAuthorizedToAllocate unless user.can_allocate?(bucket)
        allocation = user.get_allocation_for_bucket(bucket)

        remaining = user.remaining_allocation_balance(bucket.budget)
        if amount < remaining
          attributes[:amount] = remaining
        end

        Allocation.create!(attributes)
      end
    end
  end
end
