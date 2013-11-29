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

        #puts attributes.inspect

        remaining = Money.new(user.remaining_allocation_balance(bucket.budget))
        #puts amount.inspect
        #puts remaining.inspect

        if amount.amount > remaining.amount
          puts 'Too much'
          attributes[:amount] = Money.new(remaining.amount)
        end

        #puts attributes.inspect

        Allocation.create!(attributes)
      end
    end
  end
end
