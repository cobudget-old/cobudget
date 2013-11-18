require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module Allocations
    class Perform < Playhouse::Context
      class NotAuthorizedToAllocate < Exception; end

      actor :admin, repository: User#, role: BucketAuthorizer

      actor :user, repository: User, role: Allocator
      actor :bucket, repository: Bucket
      actor :amount

      def attributes
        actors_except :admin
      end

      def perform
        allocation = user.get_allocation_for_bucket(bucket)

        #remaining = user.remaining_allocation_balance(bucket.budget)
        #if amount < remaining
        #  attributes[:amount] = remaining
        #end

        if allocation
          allocation.update_attributes(attributes)
        else
          Allocation.create!(attributes)
        end
      end
    end
  end
end
