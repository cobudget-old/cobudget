require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/entities/account'
require 'cobudget/composers/money_composer'
require 'cobudget/roles/allocator'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module Allocations
    class Create < Playhouse::Context
      class NotAuthorizedToAllocate < Exception; end
      class InvalidAmount < Exception; end

      actor :admin, repository: User

      actor :user, repository: User, role: Allocator
      actor :bucket, repository: Bucket
      actor :amount, composer: MoneyComposer

      def get_attributes
        actors_except :admin
      end

      def perform
        raise NotAuthorizedToAllocate unless user.can_allocate?(bucket)

        user_account = user.get_allocation_rights(bucket.budget)

        transfer = Transfer.create(source_account: user_account, destination_account: bucket, amount: amount, creator: admin)
        transfer.call
      end
    end
  end
end
