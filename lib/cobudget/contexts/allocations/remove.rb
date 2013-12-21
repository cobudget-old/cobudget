require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/roles/budget_participant'

module Cobudget
  module Allocations
    class Remove < Playhouse::Context
      class NotAuthorizedToRemoveAllocation < Exception; end

      actor :admin, repository: User

      actor :user, repository: User, role: BudgetParticipant
      actor :bucket, repository: Bucket
      actor :amount

      def perform
        raise NotAuthorizedToAllocate unless user.can_allocate?(bucket)

        user_account = user.get_allocation_rights(bucket.budget).first
        transfer = TransferMoney.new(source_account: bucket, destination_account: user_account, amount: amount, creator: admin)
        transfer.call
      end
    end
  end
end
