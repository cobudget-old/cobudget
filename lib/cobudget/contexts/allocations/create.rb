require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/entities/account'
require 'cobudget/composers/money_composer'

module Cobudget
  module Allocations
    class Create < Playhouse::Context
      class NotAuthorizedToAllocate < Exception; end
      class InvalidAmount < Exception; end

      actor :admin, repository: User

      actor :user, repository: User, role: BudgetParticipant
      actor :bucket, repository: Bucket, role: TransactionCollection
      actor :amount

      def get_attributes
        actors_except :admin
      end

      def perform
        raise NotAuthorizedToAllocate unless user.can_allocate?(bucket)

        user_account = user.get_allocation_rights(bucket.budget).first
        transfer = TransferMoney.new(source_account: user_account, destination_account: bucket, amount: amount, creator: admin)
        transfer.call
      end
    end
  end
end
