require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/entities/allocation_right'
require 'cobudget/composers/money_composer'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module AllocationRights
    class Create < Playhouse::Context
      class NotAuthorizedToCreateAllocationRight < Exception; end

      actor :admin, repository: User#, role: BucketAuthorizer

      actor :user, repository: User
      actor :budget, repository: Budget
      actor :amount, composer: MoneyComposer

      def attributes
        actors_except :admin
      end

      def perform
        #raise NotAuthorizedToCreateBucket unless user.can_create_bucket?(bucket)
        AllocationRight.create!(attributes)
      end
    end
  end
end